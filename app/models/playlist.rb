class Playlist

  def initialize(playlist_profile, tracks)
    @playlist_profile = playlist_profile
    all_track_weights = tracks.map { |track| TrackWeight.new(track, playlist_profile) }

    @track_weights = tracks.count < playlist_profile.size ?  [] : select_track_weights(all_track_weights)
  end

  def select_track_weights(track_weights)
    @playlist_profile.size.times.reduce([]) do |memo,n|
      selected = track_weights.each_with_index.max_by(1) { |tw, i| tw.weights[n].random_calibrated }.first
      track_weights.delete_at(selected.last)
      memo << selected.first
    end
  end

  def tracks
    @track_weights.map(&:track)
  end

  def print_summary
    if @track_weights.empty?
      puts "There are not enough tracks available to fill the playlist"
      return
    end

    sum_differences = Hash.new(0.0)

    @playlist_profile.size.times.reduce(0) do |memo, n|
      track_weight = @track_weights[n]
      track = track_weight.track

      output = "Slot #{n}, "

      output += @playlist_profile.slot_profiles[n].criteria.map do |criteria_name, criteria|
        target = criteria.target
        value = track.send(criteria_name)

        sum_differences[criteria_name] += target ? (value - target).abs : 0

        weight = track_weight.weights[n].criteria_weights[criteria_name].round(2)

        "#{criteria_name}: #{value.round(2)} <#{criteria.min_filter} - #{target} - #{criteria.max_filter}> #{weight}"
      end.join(", ")

      weight = track_weight.weights[n].total.round(2)
      rweight = track_weight.weights[n].random_calibrated.round(4)
      output += ", Weight: #{weight} | #{rweight}, #{track.title}, #{track.id}"
      puts output
    end

    @playlist_profile.slot_profiles[0].criteria.each do |criteria_name, criteria|
      puts "#{criteria_name} avg. difference: #{(sum_differences[criteria_name]/@playlist_profile.size).round(4)}"
    end

    true

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

        slot_profile.criteria.each do |criteria_name, slot_criteria|
          value = track.send(criteria_name)

          if value < slot_criteria.min_filter || value > slot_criteria.max_filter
            @random_calibrated = -(1.0 / @random_calibrated)
          end
        end
      end
    end
  end
end
