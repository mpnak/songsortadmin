class AddStationTypeToStations < ActiveRecord::Migration
  def change
    add_column :stations, :station_type, :string, default: "standard"
  end
end
