class Track < ActiveRecord::Base

  serialize :audio_summary

  belongs_to :station
  has_many :saved_station_tracks
  has_many :saved_stations, through: :saved_station_tracks
  has_many :track_bans
  has_many :track_favorites

  validates :station, :title, :spotify_id, :artist, presence: true

  attr_accessor :favorited

  #before_create :create_in_taste_profile
  #before_destroy :destroy_from_taste_profile
  #before_update :update_taste_profile

  # set favorited = true if there is a TrackFavorite relation for that station and user
  # tracks is an array or relation of track models.
  def self.decorate_with_favorited(user_id, station_id, tracks)
    favs = TrackFavorite.where(
      track_id: tracks,
      station_id: station_id,
      user_id: user_id
    ).reduce({}) do |memo, track_favorite|
      memo[track_favorite.track_id] = true
      memo
    end

    tracks.each do |track|
      track.favorited = favs.fetch(track.id, false)
    end
  end

  def self.echo_song_from_spotify_id(spotify_id)
    spotify_track = RSpotify::Track.find(spotify_id)

    _artist = spotify_track.artists.first.name
    _title = spotify_track.name

    # TODO should we replace the track with another? (Not for now)
    #echo_song = Echowrap.song_search(title: _title, artist: _artist, :bucket => ['id:spotify', 'audio_summary', 'tracks']).first

    Echowrap.song_search(title: _title, artist: _artist, :bucket => ['audio_summary']).first
  end

  def self.build_from_spotify_id(spotify_id)
    track = Echowrap.track_profile(:id => "spotify:track:#{spotify_id}", bucket: ['audio_summary'])

    if track.id
      Track.new({
        title: track.title,
        artist: track.artist,
        spotify_id: spotify_id,
        echo_nest_id: track.id,
        echo_nest_song_id: track.song_id,
        audio_summary: track.audio_summary.attrs
      })
    else
      echo_song = echo_song_from_spotify_id(spotify_id)

      if echo_song
        Track.new({
          title: echo_song.title,
          artist: echo_song.artist_name,
          spotify_id: spotify_id,
          echo_nest_song_id: echo_song.id,
          audio_summary: echo_song.audio_summary.attrs
        })
      else
        raise "no echonest song found"
      end
    end

  end

  def self.delete_from_taste_profile(taste_profile_id, track_ids)
    data = track_ids.map do |track_id|
      {
        action: "delete",
        item: { track_id: track_id }
      }
    end

    Echowrap.taste_profile_update(
      :id => taste_profile_id,
      :data => JSON.generate(data)
    )
  end

  def get_audio_summary!
    echo_song = if self.echo_nest_song_id
                  Echowrap.song_profile(id: self.echo_nest_song_id, bucket: [:audio_summary])
                else self.echo_nest_id
                  Echowrap.song_profile(track_id: "TRSQANT144D17E0F21", bucket: [:audio_summary])
                end

    if echo_song
      self.echo_nest_song_id = echo_song.id
      self.audio_summary = echo_song.audio_summary
      self.save
    end
  end

  def create_in_taste_profile
    data = [
      {
        action: "update",
        item: { track_id: self.echo_nest_id }
      }
    ]

    Echowrap.taste_profile_update(
      :id => self.station.taste_profile_id,
      :data => JSON.generate(data)
    )
  end

  def destroy_from_taste_profile
    Track.delete_from_taste_profile(self.station.taste_profile_id, [self.echo_nest_id])
  end

  # Here we are only concerned with setting the undergroundness on the taste
  # profile
  def update_taste_profile
    return unless self.undergroundness

    data = [
      {
        action: "update",
        item: {
          track_id: self.echo_nest_id,
          item_keyvalues: {
            undergoundness: self.undergroundness
          }
        }
      }
    ]

    Echowrap.taste_profile_update(
      :id => self.station.taste_profile_id,
      :data => JSON.generate(data)
    )
  end
end
