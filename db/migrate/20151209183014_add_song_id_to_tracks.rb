class AddSongIdToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :echo_nest_song_id, :string
  end
end
