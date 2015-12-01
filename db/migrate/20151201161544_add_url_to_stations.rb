class AddUrlToStations < ActiveRecord::Migration
  def change
    add_column :stations, :url, :string
  end
end
