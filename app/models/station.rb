class Station < ActiveRecord::Base
  has_many :tracks
  has_many :track_bans
  has_many :track_favorites
  has_many :user_station_links
  has_many :playlists

  validates :name, presence: true

  DEFAULT_STATION_OPTIONS = {
    undergroundness: 3,
    saved_station: false
  }

  # attach a user_station_link here to delegate playlist options
  attr_accessor :user_station_link

  attr_accessor :playlist

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

  def generate_playlist(options = {})
    if ["featured", "sponsored"].include?(station_type)
      tracks.order(created_at: :asc)
    else
      # tracks.sample(30)

      if options[:undergroundness]
        options[:undergroundness] = options[:undergroundness].to_i
      end
      options[:undergroundness] ||= undergroundness


      playlist_profile = PlaylistProfile.choose(options)

      # for the moment print the summary each time
      @playlist = Playlist.generate(playlist_profile, self, { print_summary: options[:print] })

      if options[:print]
        puts playlist.summary[:text]
        return nil
      end

      if @user_station_link
        #@user_station_link.tracks = playlist.tracks
        #@user_station_link.tracks_updated_at = DateTime.now
        @user_station_link.playlist = @playlist
        @user_station_link.undergroundness = options[:undergroundness]
        @user_station_link.save

        # Note this will decorate with user information like favorited
        #@user_station_link.tracks_with_user_info
      end

      @playlist
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

  # use a local cache if present, otherwise look at the user_station_link
  def playlist
    return @playlist if @playlist

    return nil unless user_station_link.try(:playlist)

    return user_station_link.playlist
  end

  def undergroundness
    user_station_link ? user_station_link.undergroundness : DEFAULT_STATION_OPTIONS[:undergroundness]
  end

  def saved_station
    user_station_link ? user_station_link.saved_station : DEFAULT_STATION_OPTIONS[:saved_station]
  end

  def tracks_updated_at
    return nil unless playlist
    return playlist.created_at
  end

  def playlist_tracks
    return [] unless playlist
    return playlist.tracks unless user_station_link
    return playlist.tracks_with_user_info(user_station_link.user.id)
  end

end
