class Station < ActiveRecord::Base
  has_many :tracks
  has_many :saved_stations
  has_many :track_bans
  has_many :track_favorites
  has_many :user_station_links

  validates :name, presence: true

  def self.from_params(params)
    q = Station.all

    if params[:station_type]
      q = q.where(station_type: params[:station_type])
    end

    return q
  end

  def generate_tracks(options = {})
    if ["featured", "sponsored"].include?(station_type)
      tracks
    else
      playlist_profile = PlaylistProfile.choose(options)
      playlist = playlist_profile.playlist(self.tracks.where.not(energy: nil))

      if options[:print]
        playlist.print_summary
      else
        playlist.tracks
      end
    end
  end
end
