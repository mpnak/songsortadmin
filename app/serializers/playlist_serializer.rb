class PlaylistSerializer < ActiveModel::Serializer
  attributes :id, :undergroundness, :use_weather, :use_timeofday, :autoupdate

  has_one :station
  has_many :tracks
end
