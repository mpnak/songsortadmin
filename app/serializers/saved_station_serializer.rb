class SavedStationSerializer < ActiveModel::Serializer
  attributes :id, :undergroundness, :use_weather, :use_timeofday, :autoupdate, :updated_at

  has_one :station
  #has_many :tracks
end
