class StationSerializer < ActiveModel::Serializer
  attributes :id, :name, :short_description, :station_type, :url, :station_art, :undergroundness, :use_weather, :use_timeofday, :saved_station
end
