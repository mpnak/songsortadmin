class RemoveTasteProfileIdFromStations < ActiveRecord::Migration
  def change
    remove_column :stations, :taste_profile_id, :string
  end
end
