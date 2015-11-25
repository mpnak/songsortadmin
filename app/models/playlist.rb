class Playlist < ActiveRecord::Base
  belongs_to :user
  belongs_to :station
  has_many :playlist_tracks
  has_many :tracks, through: :playlist_tracks

  validates :user, :station, presence: true

  def generate_tracks
    self.tracks = self.station.tracks.all.sample(30)
  end
end
