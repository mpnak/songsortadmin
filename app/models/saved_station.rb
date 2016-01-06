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

  # Return [[value, index]]
  def wsamplei(n)
    #self.each_with_index.max_by(n) {|v, i| rand ** (1.0/yield(v)) }
    self.each_with_index.max_by(n) {|v, i| 0.5 ** (1.0/yield(v)) }
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

end
