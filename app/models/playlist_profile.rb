class PlaylistProfile

  # Params (all optional):
  #   name
  #   undergroundness
  #   time_of_day
  #   weather
  #
  def self.choose(options = {})
    profile_name = options[:name] || :test_high

    pl_data = PLAYLIST_PROFILES[profile_name]

    if undergroundness = options[:undergroundness]
      pl_data[:tracks].each do |td|
        td[:undergroundness][:target] = undergroundness
        td[:undergroundness][:min] = [undergroundness - 3, 0].max
        td[:undergroundness][:max] = [undergroundness + 3, 5].min
      end
    end

    if s = options[:randomness]
      pl_data[:settings][:randomness] = s
    end

    new(pl_data)
  end

  attr_reader :track_profiles

  def initialize(data)
    @data = data
    @track_profiles = data[:tracks].map {|x| TrackProfile.new(x) }
  end

  def size
    @size || @size = @data[:tracks].count
  end

  def randomness
    @data[:settings][:randomness]
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
      selected = track_weights.each_with_index.max_by(1) do |tw, i|
        TrackWeight::Weight.random_calibrated_weight(tw.weights[n].total, randomness)
      end.first

      track_weights.delete_at(selected.last)

      memo << selected.first
    end
  end

  def print_summary(playlist)
    variance = size.times.reduce(0) do |memo, n|
      track_weight = playlist[n]
      track = track_weight.track
      t_en = track_profiles[n].energy.target
      en = track.energy

      weight = track_weight.weights[n].total

      puts "target energy: #{t_en}, actual energy: #{en.round(2)}, weight: #{weight}, #{track.title}"

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

class TrackWeight
  attr_reader :track, :weights

  def initialize(track, playlist_profile)
    @track = track
    @weights = playlist_profile.size.times.map { |n| Weight.new(n, playlist_profile, track) }
  end

  class Weight

    # A value from 0 - 1 indicating how close the value is to the target.
    # In a range 0 to 20, and a target of 10. A value of 10 would yield a normalized weight of 1.0. A value of 0 would yield a value of 0.5.
    # Given a target of 20, a value of 0 would yield a normalaized_weight of 0.0.
    #
    def self.normalize(target, value, min, max)
      1 - ((target - value).abs / (max - min).to_f)
    end

    # A value of 0 - 1 indicating how close the value is to the target. Can be short circuted with target_min and target_max values which will produce a weight of 0 if they are not met.
    #
    def self.normalize_with_limits(value, target, global_min, global_max, target_min, target_max)
      if value < target_min || value > target_max
        0
      else
        normalize(target, value, global_min, global_max)
      end
    end

    # A value of 0 - 1 obtained by from combining 0 - 1 values and associated weights/factors.
    # Factors should have a sum total of 1.0, this is not strictly enforced and they will be normalized anyway.
    # combine_weights([value1, value2], [factor1, factor2])
    #
    def self.combine_weights(values, factors)
      values.each {|value| raise ArgumentError unless (value >= 0 && value <= 1) }

      total_factors = factors.reduce(&:+).to_f

      normalized_factors = factors.map { |factor| factor / total_factors }

      values.each_with_index.reduce(0) do |memo, (value, i)|
        memo += value * normalized_factors[i]
      end
    end

    # A value of 0 - 1 obtained by adding a random element to weight from 0-1.
    #
    def self.random_calibrated_weight(value, randomness, random_number = rand)
      value * (1 - randomness) + random_number * randomness
    end

    attr_reader :energy, :undergroundness, :total

    def initialize(n, playlist_profile, track)
      track_profile = playlist_profile.track_profiles[n]

      @undergroundness = self.class.normalize_with_limits(
        track.undergroundness,
        track_profile.undergroundness.target,
        playlist_profile.min_undergroundness,
        playlist_profile.max_undergroundness,
        track_profile.undergroundness.min,
        track_profile.undergroundness.max
       )

      @energy = self.class.normalize_with_limits(
        track.energy,
        track_profile.energy.target,
        playlist_profile.min_energy,
        playlist_profile.max_energy,
        track_profile.energy.min,
        track_profile.energy.max
      )

      @total = self.class.combine_weights(
        [@undergroundness, @energy],
        [playlist_profile.undergroundness_multiplier, playlist_profile.energy_multiplier]
      )
    end

  end
end

