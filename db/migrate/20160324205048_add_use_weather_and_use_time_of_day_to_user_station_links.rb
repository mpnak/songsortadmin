class AddUseWeatherAndUseTimeOfDayToUserStationLinks < ActiveRecord::Migration
  def change
    add_column :user_station_links, :use_weather, :boolean, default: true
    add_column :user_station_links, :use_timeofday, :boolean, default: true
  end
end
