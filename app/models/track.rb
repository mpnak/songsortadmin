class Track < ActiveRecord::Base

  serialize :audio_summary, Hash

  belongs_to :station
  #has_many :saved_station_tracks
  #has_many :saved_stations, through: :saved_station_tracks
  has_many :track_bans
  has_many :track_favorites

  validates :station, :title, :spotify_id, :artist, presence: true

  attr_accessor :favorited

  # set favorited = true if there is a TrackFavorite relation for that station and user
  # tracks is an array or relation of track models.
  def self.decorate_with_user_info(user_id, station_id, tracks)
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

  # def self.echo_song_from_spotify_id(spotify_id)
  #   spotify_track = RSpotify::Track.find(spotify_id)
  #
  #   _artist = spotify_track.artists.first.name
  #   _title = spotify_track.name
  #
  #   # TODO should we replace the track with another? (Not for now)
  #   #echo_song = Echowrap.song_search(title: _title, artist: _artist, :bucket => ['id:spotify', 'audio_summary', 'tracks']).first
  #
  #   Echowrap.song_search(title: _title, artist: _artist, :bucket => ['audio_summary']).first
  # end


  # A lazy hack to get a hash version of Spotifys audio_features.
  # Purpose: to treat audio_features in exactly the same way we have been
  # treating audio_summary from echonest
  def self.extract_audio_summary_from_audio_features(audio_features)
    Hash[audio_features.instance_variables.map { |name| [name.to_s.tr('@','').to_sym, audio_features.instance_variable_get(name)] } ]
  end

  def self.build_from_spotify_id(spotify_id)
    (spotify_track, audio_summary) = get_spotify_track_and_audio_summary(spotify_id)

    Track.new({
      title: spotify_track.name,
      artist: spotify_track.artists.map(&:name).join(', '),
      spotify_id: spotify_id,
      audio_summary: audio_summary,
      energy: audio_summary[:energy],
      valence: audio_summary[:valence]
    })
  end

  def self.get_spotify_track_and_audio_summary(spotify_id)
    spotify_track = RSpotify::Track.find(spotify_id)
    raise "no spotify track found" unless spotify_track.id
    audio_features = spotify_track.audio_features
    raise "no audio_features for spotify track #{spotify_track.id}" unless audio_features
    audio_summary = extract_audio_summary_from_audio_features(audio_features)
    [spotify_track, audio_summary]
  end

  def get_audio_summary!
    (spotify_track, audio_summary) = get_spotify_track_and_audio_summary(self.spotify_id)

    self.audio_summary = audio_summary
    self.energy = audio_summary[:energy]
    self.save
  end

  # def self.build_from_spotify_id(spotify_id)
  #   echo_track = Echowrap.track_profile(:id => "spotify:track:#{spotify_id}", bucket: ['audio_summary'])
  #
  #   if echo_track.id
  #     Track.new({
  #       title: echo_track.title,
  #       artist: echo_track.artist,
  #       spotify_id: spotify_id,
  #       #echo_nest_id: echo_track.id,
  #       echo_nest_song_id: echo_track.song_id,
  #       audio_summary: echo_track.audio_summary.attrs,
  #       energy: echo_track.audio_summary.attrs[:energy],
  #       valence: echo_track.audio_summary.attrs[:valence]
  #     })
  #   else
  #     echo_song = echo_song_from_spotify_id(spotify_id)
  #
  #     if echo_song
  #       Track.new({
  #         title: echo_song.title,
  #         artist: echo_song.artist_name,
  #         spotify_id: spotify_id,
  #         echo_nest_song_id: echo_song.id,
  #         audio_summary: echo_song.audio_summary.attrs,
  #         energy: echo_song.audio_summary.attrs[:energy],
  #         valence: echo_song.audio_summary.attrs[:valence]
  #       })
  #     else
  #       raise "no echonest song found"
  #     end
  #   end
  #
  # end
  # def get_audio_summary!
  #   echo_song = if self.echo_nest_song_id
  #                 Echowrap.song_profile(id: self.echo_nest_song_id, bucket: [:audio_summary])
  #               else self.echo_nest_id
  #                 Echowrap.song_profile(track_id: echo_nest_id, bucket: [:audio_summary])
  #               end
  #
  #   if echo_song
  #     self.echo_nest_song_id = echo_song.id
  #     self.audio_summary = echo_song.audio_summary.attrs
  #     self.energy = echo_song.audio_summary.attrs[:energy]
  #     self.save
  #   end
  # end

  # def energy
  #   audio_summary[:energy].to_f
  # end

  # def valence
  #   audio_summary[:valence].to_f
  # end
end
