class CreateUserStationLinks < ActiveRecord::Migration
  def change
    create_table :user_station_links do |t|
      t.references :user, index: true
      t.references :station, index: true
      t.text :track_ids

      t.timestamps
    end
  end
end
