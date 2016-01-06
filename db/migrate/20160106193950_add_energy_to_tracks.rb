class AddEnergyToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :energy, :decimal
  end
end
