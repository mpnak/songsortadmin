class RenamePlaylistTracksToSavedStationTracks < ActiveRecord::Migration
  def change
    rename_table :playlist_tracks, :saved_station_tracks
    rename_column :saved_station_tracks, :playlist_id, :saved_station_id
  end
end
