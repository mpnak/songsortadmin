class SavedStation < ActiveRecord::Base
  belongs_to :user
  belongs_to :station
  has_many :saved_station_tracks
  has_many :tracks, through: :saved_station_tracks

  validates :user, :station, presence: true
  validates :station, uniqueness: { scope: :user }
  validates :undergroundness, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  before_save :set_undergroundness

  def playlist_options
    {
      undergroundness: self.undergroundness,
      use_weather: true,
      use_time_of_day: true
    }
  end

  def generate_tracks(options = {})
    self.touch
    self.tracks = self.station.generate_tracks(playlist_options.merge(options))
  end

  private

  def set_undergroundness
    self.undergroundness ||= 3
  end
end
