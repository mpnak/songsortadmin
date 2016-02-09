class AddUserIndexToSavedStations < ActiveRecord::Migration
  def change
    add_index :saved_stations, :user_id
  end
end
