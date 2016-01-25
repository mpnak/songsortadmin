class PlaylistProfileChooser
  SCORE_FOR_FORECASTIO_ICONS = {
    "clear-day" => 8,
    "clear-night" => 7,
    "rain" => 1,
    "snow" => 6,
    "sleet" => 1,
    "wind" => 5,
    "fog" => 3,
    "cloudy" => 3,
    "partly-cloudy-day" => 6,
    "partly-cloudy-night" => 5,
    "partly-cloudy" => 5
  }

  DAY_TIME_SCORES = [
  #03:05  5:7   7:9  9:11  11:13 13:17 17:19 19:21 21:23 23:02  
    [5,    5,    4,    7,    5,    6,    6,    7,    4,    5], # Sunday
    [1,    1,    3,    5,    5,    5,    6,    4,    4,    6], # Monday
    [1,    3,    3,    6,    7,    7,    6,    5,    4,    6], # Tuesday
    [1,    3,    4,    6,    7,    7,    6,    5,    5,    6], # Wednesday
    [3,    4,    4,    7,    7,    8,    8,    7,    7,    7], # Thursday
    [5,    5,    5,    7,    8,    8,    7,    9,    9,    7], # Friday
    [5,    4,    5,    7,    7,    8,    8,    10,    10,    7], # Saturday
  ]

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
    [21, 7],
    [24, 8]
  ]

  PLAYLIST_SCORES = {
    mellow: 2.5,
    chill: 3.5,
    vibes: 5.9,
    lounge: 6.9,
    club: 8.4,
    bangin: 10
  }

  def self.choose_name(options = {})
    # Get local weather
    options[:ll] ||= "33.985488,-118.475250" # Venice beach

    latlng = options[:ll].split(',').map(&:to_f)
    forecast = ForecastIO.forecast(*latlng)
    options[:timezone] = forecast["timezone"]
    localtime = ActiveSupport::TimeZone[options[:timezone]].now

    options[:weather] ||= forecast["currently"]["icon"]
    options[:hour] ||= localtime.hour
    options[:day] ||= localtime.wday

    choose_name_by_values(options[:weather], options[:day], options[:hour], options)
  end

  def self.choose_name_by_values(weather, day, hour, options = {})
    weather_score = score_for_forecastio_icon(weather)
    day_time_score = score_for_day_index_time_index(day, time_index_from_hour(hour))
    total_score = (weather_score + day_time_score) / 2.0

    name = playlist_name(total_score)

    if options[:print]
      puts "=========== PlaylistProfileChooser.choose ============="
      puts "Location: #{options[:ll]}, Timezone: #{options[:timezone]}"
      puts "Weather: #{weather}, Score: #{weather_score}"
      puts "Hour: #{hour}, Day: #{day}, Score: #{day_time_score}"
      puts "Name: #{name}, Score: #{total_score}"
      puts "==============================="
    end

    name
  end

  private

  def self.score_for_forecastio_icon(icon_name)
    SCORE_FOR_FORECASTIO_ICONS.fetch(icon_name) { rand(10) +1 }
  end

  def self.playlist_name(score)
    PLAYLIST_SCORES.each do |name, value|
      return name if score <= value
    end
  end

  def self.score_for_day_index_time_index(day_index, time_index)
    DAY_TIME_SCORES[day_index][time_index]
  end

  def self.time_index_from_hour(hour)
    TIME_LOWER_BOUND_AND_INDEXES.bsearch {|(lbound, _)| hour <= lbound }.last
  end
end
