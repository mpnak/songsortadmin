class AddUndergroundnessToUserStationLink < ActiveRecord::Migration
  def change
    add_column :user_station_links, :undergroundness, :integer, default: 3
  end
end
