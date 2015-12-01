class StationSerializer < ActiveModel::Serializer
  attributes :id, :name, :short_description, :station_type
end
