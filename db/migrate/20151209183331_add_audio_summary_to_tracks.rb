class AddAudioSummaryToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :audio_summary, :text
  end
end
