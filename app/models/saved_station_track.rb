class SavedStationTrack < ActiveRecord::Base
  belongs_to :saved_station
  belongs_to :track
end
