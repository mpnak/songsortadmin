class UserStationLink < ApplicationRecord
  belongs_to :user
  belongs_to :station
  belongs_to :playlist

  serialize :track_ids, Array

  validates :undergroundness, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  # def tracks
  #   # Find all corresponding Tracks from track_ids and retain the order they have in track_ids
  #   Track.find(track_ids).index_by(&:id).slice(*track_ids).values
  # end

  # def tracks_with_user_info
  #   #Track.decorate_with_user_info(user.id, station.id, tracks)
  #
  #   return [] unless playlist
  #   Track.decorate_with_user_info(user.id, station.id, playlist.tracks)
  # end

  # # val is an array of Track
  # def tracks=(val)
  #   self.track_ids = val.map { |track| track.id }
  # end
end
