class Station < ActiveRecord::Base
  has_many :tracks
  has_many :saved_stations
  has_many :track_bans
  has_many :track_favorites
  has_many :user_station_links

  validates :name, presence: true

  DEFAULT_PLAYLIST_OPTIONS = {
    undergroundness: 3,
    use_weather: true,
    use_time_of_day: true
  }

  def self.from_params(params)
    q = Station.all

    if params[:station_type]
      q = q.where(station_type: params[:station_type])
    end

    return q
  end

  def playlist_options
    DEFAULT_PLAYLIST_OPTIONS
  end

  def generate_tracks(options = {})
    if ["featured", "sponsored"].include?(station_type)
      tracks.where(created_at: :asc)
    else
      # tracks.sample(30)
      options = playlist_options.merge(options)

      playlist_profile = PlaylistProfile.choose(options)

      cleaned_tracks = self.tracks
        .where.not(energy: nil)
        .where.not(undergroundness: nil)
        .where.not(valence: nil)

      playlist = playlist_profile.playlist(cleaned_tracks)

      playlist.print_summary

      if options[:print]
        playlist.print_summary
        return nil
      end

      playlist.tracks
    end
  end
end
