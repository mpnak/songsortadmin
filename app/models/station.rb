class Station < ActiveRecord::Base
  has_many :tracks
  has_many :saved_stations
  has_many :track_bans
  has_many :track_favorites
  has_many :user_station_links

  validates :name, presence: true

  DEFAULT_STATION_OPTIONS = {
    undergroundness: 3,
    use_weather: true,
    use_timeofday: true,
    saved_station: false
  }

  # attach a user_station_link here to delegate playlist options
  attr_accessor :user_station_link

  def self.find_with_user(id, user=nil)
    Station.find(id).decorate_with_user_info(user)
  end

  def self.find_with_user!(id, user=nil)
    Station.find(id).decorate_with_user_info!(user)
  end

  def self.from_params(params, user=nil)
    q = if user
          Station.includes(:user_station_links)
        else
          Station.all
        end

    if params[:saved_station] == true && user
      q = q.where(user_station_links: { user: user, saved_station: true })
    end

    if params[:station_type]
      q = q.where(station_type: params[:station_type])
    end

    q = q.order(updated_at: :desc)

    return q.map {|s| s.decorate_with_user_info(user) }
  end

  def generate_tracks(options = {})
    if ["featured", "sponsored"].include?(station_type)
      tracks.order(created_at: :asc)
    else
      # tracks.sample(30)

      options[:undergroundness] = undergroundness
      options[:use_weather] = use_weather
      options[:use_timeofday] = use_timeofday

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

      if @user_station_link
        @user_station_link.tracks = playlist.tracks
        @user_station_link.save

        # Note this will decorate with user information like favorited
        @user_station_link.tracks_with_user_info
      else
        playlist.tracks
      end
    end
  end

  def decorate_with_user_info(user = nil)
    if user
      @user_station_link = user_station_links.where(user: user).first
    end
    self
  end

  def decorate_with_user_info!(user = nil)
    if user
      @user_station_link = user_station_links.where(user: user).first_or_create
    end
    self
  end

  # Delegated methods

  def undergroundness
    user_station_link ? user_station_link.undergroundness : DEFAULT_STATION_OPTIONS[:undergroundness]
  end

  def use_weather
    user_station_link ? user_station_link.use_weather : DEFAULT_STATION_OPTIONS[:use_weather]
  end

  def use_timeofday
    user_station_link ? user_station_link.use_timeofday : DEFAULT_STATION_OPTIONS[:use_timeofday]
  end

  def saved_station
    user_station_link ? user_station_link.saved_station : DEFAULT_STATION_OPTIONS[:saved_station]
  end
  #

end
