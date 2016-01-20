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
      tracks.sample(30)

      # playlist_profile = PlaylistProfile.choose(options)
      #
      # cleaned_tracks = self.tracks
      #   .where.not(energy: nil)
      #   .where.not(undergroundness: nil)
      #   .where.not(valence: nil)
      #
      # playlist = playlist_profile.playlist(cleaned_tracks)
      #
      # if options[:print]
      #   playlist.print_summary
      #   return nil
      # end
      #
      # playlist.tracks
    end
  end
end
