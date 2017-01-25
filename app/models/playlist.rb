# profile_name
# undergroundness
# tracks, array
# summary, hash
# station_id, belongs_to

class Playlist < ApplicationRecord

  belongs_to :station
  serialize :tracks, Array
  serialize :summary, Hash

  def self.generate(playlist_profile, station, options = {})

    tracks = station.tracks
        .where.not(energy: nil)
        .where.not(undergroundness: nil)
        .where.not(valence: nil)
        .group_by(&:artist).map{|k, v| v.first}
   
    all_track_weights = tracks.map { |track| TrackWeight.new(track, playlist_profile) }

    track_weights = tracks.count < playlist_profile.size ?  [] : select_track_weights(all_track_weights, playlist_profile)

    Playlist.create(
      station: station,
      profile_name: playlist_profile.name,
      undergroundness: playlist_profile.undergroundness,
      tracks: track_weights.map(&:track),
      summary: options[:print_summary] ? { text: print_summary(track_weights, playlist_profile) } : {}
    )

  end

  def self.select_track_weights(track_weights, playlist_profile)
    playlist_profile.size.times.reduce([]) do |memo,n|
      selected = track_weights.each_with_index.max_by(1) do |tw, i|
        tw.weights[n].random_calibrated
      end.first
      track_weights.delete_at(selected.last)
      memo << selected.first
    end
  end

  def self.print_summary(track_weights, playlist_profile)
    if track_weights.empty?
      puts "There are not enough tracks available to fill the playlist"
      return
    end

    output = ""

    sum_differences = Hash.new(0.0)

    playlist_profile.size.times.reduce(0) do |memo, n|
      track_weight = track_weights[n]
      track = track_weight.track

      row_output = "Slot #{n}, "

      row_output += playlist_profile.slot_profiles[n].criteria.map do |criteria_name, criteria|
        target = criteria.target
        value = track.send(criteria_name)

        sum_differences[criteria_name] += target ? (value - target).abs : 0

        weight = track_weight.weights[n].criteria_weights[criteria_name].round(2)

        "#{criteria_name}: #{value.round(2)} <#{criteria.min_filter} - #{target} - #{criteria.max_filter}> #{weight}"
      end.join(", ")

      weight = track_weight.weights[n].total.round(2)
      rweight = track_weight.weights[n].random_calibrated.round(4)
      row_output += ", Weight: #{weight} | #{rweight}, #{track.title}, #{track.artist}"
      output += row_output + "\n"
    end

    playlist_profile.slot_profiles[0].criteria.each do |criteria_name, criteria|
      output += "#{criteria_name} avg. difference: #{(sum_differences[criteria_name]/playlist_profile.size).round(4)}"
    end

    output
  end

  def tracks_with_user_info(user_id)
    Track.decorate_with_user_info(user_id, station.id, tracks)
  end

  class TrackWeight
    attr_reader :track, :weights

    def initialize(track, playlist_profile)
      @track = track
      @weights = playlist_profile.size.times.map { |n| Weight.new(n, playlist_profile, track) }
    end

    class Weight

      # A value of 0 - 1 obtained by from combining 0 - 1 values and associated weights/factors.
      # Factors should have a sum total of 1.0, this is not strictly enforced and they will be normalized anyway.
      # combine_weights([value1, value2], [factor1, factor2])
      #
      def self.combine_weights(values, factors)
        values.each {|value| raise ArgumentError.new("value must be [0,1]. value: #{value}") unless (value >= 0 && value <= 1) }

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

      attr_reader :total, :random_calibrated, :criteria_weights

      def initialize(n, playlist_profile, track)

        slot_profile = playlist_profile.slot_profiles[n]

        @criteria_weights = {}
        factors = []

        slot_profile.criteria.each do |criteria_name, slot_criteria|
          @criteria_weights[criteria_name] = slot_criteria.normalized_score(track.send(criteria_name))
          factors << slot_criteria.multiplier
        end

        @total = self.class.combine_weights(@criteria_weights.values, factors)

        @random_calibrated = self.class.random_calibrated_weight(@total, slot_profile.randomness)

        out_of_bounds = slot_profile.criteria.map do |criteria_name, slot_criteria|
          value = track.send(criteria_name)
          value < slot_criteria.min_filter || value > slot_criteria.max_filter
        end.reduce(:|)

        if out_of_bounds
          @random_calibrated = -(1.0 / @random_calibrated)
        end
      end
    end
  end
end
