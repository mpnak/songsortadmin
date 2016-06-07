class StationSerializer < ActiveModel::Serializer
  attributes :id, :name, :short_description, :station_type, :url, :station_art, :undergroundness, :saved_station, :tracks_updated_at
end
