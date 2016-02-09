class AddUserStationIndexToSavedStations < ActiveRecord::Migration
  def change
    add_index :saved_stations, [:user_id, :station_id], unique: true
  end
end
