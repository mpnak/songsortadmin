class RenamePlaylistsToSavedStations < ActiveRecord::Migration
  def change
    rename_table :playlists, :saved_stations
  end
end
