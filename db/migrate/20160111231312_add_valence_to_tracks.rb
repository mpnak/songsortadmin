class AddValenceToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :valence, :decimal
  end
end
