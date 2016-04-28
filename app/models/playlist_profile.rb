class PlaylistProfile
  def self.choose(options = {})
    name = options[:name] || PlaylistProfileChooser.new(options).name
    new(name, options)
  end

  attr_reader :slot_profiles, :size

  def initialize(name, options = {})
    data = PLAYLIST_PROFILES[name].dup

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
          [cr.target + criteria_data[:slot_min_delta], cr.global_min].max
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
