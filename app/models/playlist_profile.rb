class PlaylistProfile

  WEATHER_SCORES = {
    rain: 2,
    snow: 6,
    sleet: 3,
    fog: 4,
    cloudy: 4,
    partly_cloudy: 5,
    clear: 10,
    windy: 6
  }

  DAY_TIME_SCORES = [
    # 5:7   7:9   9:11 11:13 13:17 17:19 19:21 21:00 00:3   3:5
    [1,    3,    4,    6,    7,    6,    6,    5,    7,    6], # Monday
    [1,    3,    4,    6,    7,    7,    6,    5,    7,    6], # Tuesday
    [1,    3,    5,    6,    7,    7,    6,    5,    7,    6], # Wednesday
    [3,    4,    6,    7,    7,    8,    8,    7,    10,    7], # Thursday
    [5,    5,    6,    7,    6,    9,    8,    9,    10,    7], # Friday
    [5,    6,    6,    7,    7,    8,    8,    10,    10,    7], # Saturday
    [5,    7,    6,    7,    7,    6,    6,    7,    9,    6], # Sunday
  ]

  DAY_INDEXES = {
    mon: 0,
    tue: 1,
    wed: 2,
    thu: 3,
    fri: 4,
    sat: 5,
    sun: 6
  }

  TIME_LOWER_BOUND_AND_INDEXES = [
    [0, 8],
    [3, 9],
    [5, 0],
    [7, 1],
    [9, 2],
    [11, 3],
    [13, 4],
    [17, 5],
    [19, 6],
    [21, 7]
  ]


  # Params (all optional):
  #   name
  #   undergroundness
  #   time_of_day
  #   weather
  #
  def self.choose(options = {})

    options[:weather] ||= :clear
    options[:day] ||= :sat
    options[:time] ||= 12

    weather_score = WEATHER_SCORES[options[:weather]]
    day_index = DAY_INDEXES[options[:day]]
    hour = options[:time].floor
    time_index = TIME_LOWER_BOUND_AND_INDEXES.bsearch {|(lbound, _)|  hour > lbound }.last
    day_time_score = DAY_TIME_SCORES[day_index][time_index]
    total_score = (weather_score + day_time_score) / 2.0
    playlist_name = playlist_name(total_score)

    options[:name] ||= (playlist_name || :mellow)
    options[:undergroundness] ||= 3

    new(options)
  end

  def self.playlist_name(score)
    case
    when score <= 2.5
      :mellow
    when score <= 3
      :chill
    when score <= 5.5
      :vibes
    when score <= 7
      :lounge
    when score <= 8.5
      :club
    when score <= 10
      :bangin
    else
      :vibes
    end
  end

  attr_reader :slot_profiles, :size

  def initialize(options = {})
    #data = PLAYLIST_PROFILES[options[:name]].dup
    data = PLAYLIST_PROFILES[:mellow].dup

    if undergroundness = options[:undergroundness]
      data[:slots].each do |slot_data|
        slot_data[:criteria][:undergroundness] ||= {}
        slot_data[:criteria][:undergroundness][:target] = undergroundness
      end
    end

    @slot_profiles = data[:slots].each_with_index.map {|x, i| SlotProfile.new(data, i) }
    @size = @slot_profiles.count
  end

  def playlist(tracks)
    Playlist.new(self, tracks)
  end

  class SlotProfile
    attr_reader :criteria, :randomness

    def initialize(data, slot_index)
      @randomness = data[:randomness] || 0.8

      @criteria = {}

      data[:criteria].each do |name, criteria_data|
        slot_criteria_data = data[:slots][slot_index][:criteria][name] || {}

        cr = Criteria.new

        cr.name = name
        cr.multiplier = slot_criteria_data[:multiplier] || criteria_data[:multiplier] || 1.0
        cr.global_min = criteria_data[:min] || 0
        cr.global_max = criteria_data[:max] || 1
        cr.target = slot_criteria_data[:target]

        cr.min_filter = slot_criteria_data[:min] || if criteria_data[:slot_min_delta] && cr.target
        [cr.target - criteria_data[:slot_min_delta], cr.global_min].max
        else
          cr.global_min
        end

        cr.max_filter = slot_criteria_data[:max] || if criteria_data[:slot_max_delta] && cr.target
        [cr.target + criteria_data[:slot_max_delta], cr.global_max].min
        else
          cr.global_max
        end

        @criteria[name] = cr
      end
    end

    class Criteria
      attr_accessor :name, :target, :min_filter, :max_filter, :global_min, :global_max, :multiplier

      # A value from 0 - 1 indicating how close the value is to the target.
      # In a range 0 to 20, and a target of 10. A value of 10 would yield a normalized weight of 1.0. A value of 0 would yield a value of 0.5.
      # Given a target of 20, a value of 0 would yield a normalaized_weight of 0.0.
      #
      def normalized_score(value)
        self.target ? 1 - ((self.target - value).abs / (self.global_max - self.global_min).to_f) : 0
      end

    end
  end
end
