class TrackBan < ApplicationRecord
  belongs_to :user
  belongs_to :station
  belongs_to :track
end
