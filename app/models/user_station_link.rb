class UserStationLink < ActiveRecord::Base
  belongs_to :user
  belongs_to :station

  serialize :track_ids, Array

  def tracks
    # Find all corresponding Tracks from track_ids and retain the order they have in track_ids
    Track.find(track_ids).index_by(&:id).slice(*track_ids).values
  end

  # val is an array of Track
  def tracks=(val)
    self.track_ids = val.map { |track| track.id }
  end
end
