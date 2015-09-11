class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.integer :station_id
      t.string :spotify_id
      t.string :name
      t.string :artist
      t.integer :undergroundness

      t.timestamps
    end
  end
end
