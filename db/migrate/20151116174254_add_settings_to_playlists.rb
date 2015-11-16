class AddSettingsToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :station_id, :integer
    add_column :playlists, :undergroundness, :int
    add_column :playlists, :use_weather, :boolean
    add_column :playlists, :use_timeofday, :boolean
    add_column :playlists, :autoupdate, :boolean
  end
end
