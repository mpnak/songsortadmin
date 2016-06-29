class StationWithTracksSerializer < ActiveModel::Serializer
  self.root = "station"

  attributes :id, :name, :short_description, :station_type, :url, :station_art, :undergroundness, :saved_station, :tracks_updated_at
  has_many :tracks

  def tracks
    object.playlist_tracks
  end

end
