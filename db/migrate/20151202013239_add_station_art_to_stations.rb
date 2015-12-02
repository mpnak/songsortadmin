class AddStationArtToStations < ActiveRecord::Migration
  def change
    add_column :stations, :station_art, :string
  end
end
