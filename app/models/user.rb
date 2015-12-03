class User < ActiveRecord::Base
  has_many :saved_stations
end
