class AddSavedStationToUserStationLink < ActiveRecord::Migration
  def change
    add_column :user_station_links, :saved_station, :boolean, default: false
  end
end
