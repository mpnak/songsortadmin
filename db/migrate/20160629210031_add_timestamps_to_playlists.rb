class AddTimestampsToPlaylists < ActiveRecord::Migration
  def change
    add_timestamps :playlists
  end
end
