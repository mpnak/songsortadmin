class User < ActiveRecord::Base
  has_many :saved_stations
  has_many :track_bans
end
