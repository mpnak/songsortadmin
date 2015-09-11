class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.integer :station_id
      t.string :spotify_id
      t.string :echo_nest_id
      t.string :title
      t.string :artist
      t.integer :undergroundness

      t.timestamps
    end
  end
end
