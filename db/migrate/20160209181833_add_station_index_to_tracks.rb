class AddStationIndexToTracks < ActiveRecord::Migration
  def change
    add_index :tracks, :station_id
  end
end
