class AddPlaylistToUserStationLinks < ActiveRecord::Migration
  def change
    add_column :user_station_links, :playlist_id, :integer
  end
end
