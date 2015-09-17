class Track < ActiveRecord::Base
  belongs_to :station

  validates :station, :title, :spotify_id, :echo_nest_id, :artist, presence: true

  before_create :create_in_taste_profile
  before_destroy :destroy_from_taste_profile
  before_update :update_taste_profile

  def self.build_from_spotify_id(spotify_id)
    track = Echowrap.track_profile(:id => "spotify:track:#{spotify_id}")

    Track.new({
      title: track.title,
      artist: track.artist,
      spotify_id: spotify_id,
      echo_nest_id: track.id
    })
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
    data = [
      {
        action: "delete",
        item: { track_id: self.echo_nest_id }
      }
    ]

    Echowrap.taste_profile_update(
      :id => self.station.taste_profile_id,
      :data => JSON.generate(data)
    )
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
