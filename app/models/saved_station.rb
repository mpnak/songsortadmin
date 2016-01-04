module Enumerable
  # weighted random sampling.
  #
  # Pavlos S. Efraimidis, Paul G. Spirakis
  # Weighted random sampling with a reservoir
  # Information Processing Letters
  # Volume 97, Issue 5 (16 March 2006)
  def wsample(n)
    self.max_by(n) {|v| rand ** (1.0/yield(v)) }
  end
end

class SavedStation < ActiveRecord::Base
  belongs_to :user
  belongs_to :station
  has_many :saved_station_tracks
  has_many :tracks, through: :saved_station_tracks

  validates :user, :station, presence: true

  def generate_tracks(options = {})
    self.touch
    self.tracks = self.station.generate_tracks
  end

  def get_energy_profile(options = {})
    # Get local weather
    if options[:ll]
      # GET weather
      latlng = options[:ll].split(',').map(&:to_f)
      forecast = ForecastIO.forecast(*latlng)
    end

    # Get current timezone
    if options[:time]
    else
      # We can still get this but need to call out to another API
      if options[:ll]
        timezone = Timezone::Zone.new(:latlon => res.ll)
        time = timezone.time Time.now
      end
    end
  end

  def fill_energy_profile(undergroundness = 3)
    pl_data = playlist_profile_data

    pl_data[:tracks].each do |td|
      td[:undergroundness][:target] = undergroundness
      td[:undergroundness][:min] = [undergroundness - 3, 0].max
      td[:undergroundness][:max] = [undergroundness + 3, 5].min
    end

    playlist_profile = PlaylistProfile.new(playlist_profile_data)
    playlist = playlist_profile.playlist(self.station.tracks)
    playlist_profile.print_summary(playlist)
  end

  class TrackWeight
    attr_reader :track, :weights

    def initialize(track, playlist_profile)
      @track = track
      @weights = playlist_profile.size.times.map { |n| Weight.new(n, playlist_profile, track) }
    end

    class Weight

      def self.normalize(target, value, min, max)
        1 - ((target - value).abs / (max - min).to_f)
      end

      def self.normalized_weight(value, target, target_min, target_max, global_min, global_max)
        if value < target_min || value > target_max
          0
        else
          normalize(target, value, global_min, global_max)
        end
      end

      attr_reader :energy, :undergroundness, :total

      def initialize(n, playlist_profile, track)
        track_profile = playlist_profile.tracks[n]

        @undergroundness = self.class.normalized_weight(
          track.undergroundness,
          track_profile.undergroundness.target,
          track_profile.undergroundness.min,
          track_profile.undergroundness.max,
          playlist_profile.min_undergroundness,
          playlist_profile.max_undergroundness
        )

        @energy = self.class.normalized_weight(
          track.energy,
          track_profile.energy.target,
          track_profile.energy.min,
          track_profile.energy.max,
          playlist_profile.min_energy,
          playlist_profile.max_energy
        )

        @total = @undergroundness * track_profile.undergroundness.multiplier * playlist_profile.undergroundness_multiplier +
          @energy * track_profile.energy.multiplier * playlist_profile.energy_multiplier
      end

    end
  end

  class PlaylistProfile

    attr_reader :tracks

    def initialize(data)
      @data = data
      @tracks = data[:tracks].map {|x| TrackProfile.new(x) }
    end

    def size
      @size || @size = @data[:tracks].count
    end

    def sensitivity
      @data[:settings][:sensitivity]
    end

    def energy_multiplier
      @data[:settings][:energy_multiplier]
    end

    def undergroundness_multiplier
      @data[:settings][:energy_multiplier]
    end

    def min_undergroundness
      1
    end

    def max_undergroundness
      5
    end

    def min_energy
      0.0
    end

    def max_energy
      1.0
    end

    def playlist(tracks)
      # Each track is associated with an array of weights for a given target vecor
      track_weights = tracks.map { |track| TrackWeight.new(track, self) }

      choose_tracks(track_weights)
    end

    def choose_tracks(track_weights)
      size.times.reduce([]) do |memo,n|
        memo << track_weights.wsample(1) do |tw|
          x = tw.weights[n].total
          Math.exp( x ** sensitivity)
        end.first
      end
    end

    def print_summary(playlist)
      variance = size.times.reduce(0) do |memo, n|
        t_en = tracks[n].energy.target
        en = playlist[n].track.energy

        puts "target energy: #{t_en}, actual energy: #{en}"

        memo += ( en - t_en ).abs ** 2
      end / size.to_f

      puts "variance: #{variance}"
    end

    class TrackProfile
      attr_reader :energy, :undergroundness

      def initialize(data)
        @energy = Criteria.new(data[:energy])
        @undergroundness = Criteria.new(data[:undergroundness])
      end

      class Criteria
        attr_accessor :target, :min, :max, :multiplier

        def initialize(data)
          @target = data[:target]
          @min = data[:min]
          @max = data[:max]
          @multiplier = data[:multiplier]
        end
      end

    end

  end

  def playlist_profile_data
    {
      settings: {
        sensitivity: 1.0,
        energy_multiplier: 10.0,
        undergroundness_muliplier: 1.0,
        size: 12
      },
      tracks: [
        {
          energy: { target: 0.4, min: 0, max: 1, multiplier: 1.0 },
          undergroundness: { target: 3, min: 0, max: 5, multiplier: 1.0 }
        },
        {
          energy: { target: 0.4, min: 0, max: 1, multiplier: 1.0 },
          undergroundness: { target: 3, min: 0, max: 5, multiplier: 1.0 }
        },
        {
          energy: { target: 0.4, min: 0, max: 1, multiplier: 1.0 },
          undergroundness: { target: 3, min: 0, max: 5, multiplier: 1.0 }
        },
        {
          energy: { target: 0.4, min: 0, max: 1, multiplier: 1.0 },
          undergroundness: { target: 3, min: 0, max: 5, multiplier: 1.0 }
        },
        {
          energy: { target: 0.4, min: 0, max: 1, multiplier: 1.0 },
          undergroundness: { target: 3, min: 0, max: 5, multiplier: 1.0 }
        },
        {
          energy: { target: 0.4, min: 0, max: 1, multiplier: 1.0 },
          undergroundness: { target: 3, min: 0, max: 5, multiplier: 1.0 }
        },
        {
          energy: { target: 0.4, min: 0, max: 1, multiplier: 1.0 },
          undergroundness: { target: 3, min: 0, max: 5, multiplier: 1.0 }
        },
        {
          energy: { target: 0.4, min: 0, max: 1, multiplier: 1.0 },
          undergroundness: { target: 3, min: 0, max: 5, multiplier: 1.0 }
        },
        {
          energy: { target: 0.4, min: 0, max: 1, multiplier: 1.0 },
          undergroundness: { target: 3, min: 0, max: 5, multiplier: 1.0 }
        },
        {
          energy: { target: 0.4, min: 0, max: 1, multiplier: 1.0 },
          undergroundness: { target: 3, min: 0, max: 5, multiplier: 1.0 }
        },
        {
          energy: { target: 0.4, min: 0, max: 1, multiplier: 1.0 },
          undergroundness: { target: 3, min: 0, max: 5, multiplier: 1.0 }
        },
        {
          energy: { target: 0.4, min: 0, max: 1, multiplier: 1.0 },
          undergroundness: { target: 3, min: 0, max: 5, multiplier: 1.0 }
        }
      ]
    }
  end


end
