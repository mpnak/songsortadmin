class Track < ActiveRecord::Base
  belongs_to :station
  has_many :saved_station_tracks
  has_many :saved_stations, through: :saved_station_tracks
  has_many :track_bans
  has_many :track_favorites

  validates :station, :title, :spotify_id, :echo_nest_id, :artist, presence: true

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

  def self.build_from_spotify_id(spotify_id)
    track = Echowrap.track_profile(:id => "spotify:track:#{spotify_id}")

    Track.new({
      title: track.title,
      artist: track.artist,
      spotify_id: spotify_id,
      echo_nest_id: track.id
    })
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
