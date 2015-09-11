class Track < ActiveRecord::Base
  belongs_to :station

  validates :station, :title, :spotify_id, :echo_nest_id, :artist, presence: true
end
