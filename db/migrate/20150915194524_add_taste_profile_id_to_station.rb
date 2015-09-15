class AddTasteProfileIdToStation < ActiveRecord::Migration
  def change
    add_column :stations, :taste_profile_id, :string
  end
end
