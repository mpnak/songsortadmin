class StationSerializer < ActiveModel::Serializer
  attributes :id, :name, :short_description, :station_type, :url, :station_art
end
