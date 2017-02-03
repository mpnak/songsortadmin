class PlaylistProfile
  class Criteria
    include Virtus.model

    attribute :name, String
    attribute :randomness, Float, default: 0
    attribute :multiplier, Float, default: 1
    attribute :criteria_min, Float
    attribute :criteria_max, Float
    attribute :min, Float, default: :criteria_min
    attribute :max, Float, default: :criteria_max
    attribute :target, Float
  end

  include Virtus.model

  attribute :criteria, Array[Criteria]
end
