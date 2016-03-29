class AddTracksUpdatedAtToUserStationLinks < ActiveRecord::Migration
  def change
    add_column :user_station_links, :tracks_updated_at, :datetime
  end
end
