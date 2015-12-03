class TrackBan < ActiveRecord::Base
  belongs_to :user
  belongs_to :station
  belongs_to :track
end
