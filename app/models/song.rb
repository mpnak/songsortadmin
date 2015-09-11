class Song < ActiveRecord::Base
  belongs_to :station

  validates :station, :name, :spotify_id, :artist, presence: true
end
