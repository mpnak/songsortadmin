class SavedStation < ActiveRecord::Base
  belongs_to :user
  belongs_to :station
  has_many :saved_station_tracks
  has_many :tracks, through: :saved_station_tracks

  validates :user, :station, presence: true

  def generate_tracks(options = {})

    # Get local weather
    if options[:ll]
      # GET weather
    else
      # we can still get time of day from the server
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

    self.touch
    self.tracks = self.station.generate_tracks
  end
end
