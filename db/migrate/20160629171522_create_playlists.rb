class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.integer :station_id
      t.string :profile_name
      t.integer :undergroundness
      t.text :tracks
      t.text :summary
    end
  end
end
