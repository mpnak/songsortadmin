class AddShortDescriptionToStations < ActiveRecord::Migration
  def change
    add_column :stations, :short_description, :text
  end
end
