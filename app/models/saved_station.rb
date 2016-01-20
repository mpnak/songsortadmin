class SavedStation < ActiveRecord::Base
  belongs_to :user
  belongs_to :station
  has_many :saved_station_tracks
  has_many :tracks, through: :saved_station_tracks

  validates :user, :station, presence: true

  def generate_tracks(options = {})
    self.touch
    self.tracks = self.station.generate_tracks(options)
  end
end
