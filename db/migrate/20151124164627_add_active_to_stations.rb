class AddActiveToStations < ActiveRecord::Migration
  def change
    add_column :stations, :active, :boolean, default: false
  end
end
