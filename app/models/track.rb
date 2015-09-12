class Track < ActiveRecord::Base
  belongs_to :station

  validates :station, :title, :spotify_id, :echo_nest_id, :artist, presence: true

  def self.build_from_spotify_id(spotify_id)
    track = Echowrap.track_profile(:id => "spotify:track:#{spotify_id}")

    track = Track.new({
      title: track.title,
      artist: track.artist,
      spotify_id: spotify_id,
      echo_nest_id: track.id
    })
  end
end
