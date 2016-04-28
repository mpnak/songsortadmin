class StationWithTracksSerializer < ActiveModel::Serializer
  self.root = "station"

  attributes :id, :name, :short_description, :station_type, :url, :station_art, :undergroundness, :use_weather, :use_timeofday, :saved_station, :tracks_updated_at
  has_many :tracks

  def tracks
    object.generated_tracks
  end
end
