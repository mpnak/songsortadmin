class Station < ActiveRecord::Base
  has_many :tracks
  has_many :playlists

  validates :name, presence: true

  #before_create :create_taste_profile

  def self.echo_sync
    Station.find_each do |station|
      station.echo_sync
    end
  end

  def create_taste_profile
    response = Echowrap.taste_profile_create(:name => name, :type => 'general')
    self.taste_profile_id = response.id
    raise "Taste profile was not created" unless taste_profile_id
  end

  def destroy_taste_profile
    Echowrap.taste_profile_delete(:id => self.taste_profile_id)
  end

  def taste_profile
    Echowrap.taste_profile_read(:id => self.taste_profile_id)
  end

  # Sync songs with Echo Nest.
  # Delete track locally is they don't exist remotely
  # Delete tracks remotely if they don't exist locally
  #
  def echo_sync
    track_items = taste_profile.items.select do |echo_item|
      echo_item.attrs[:track_id]
    end

    local_track_ids = self.tracks.pluck(:echo_nest_id)
    remote_track_ids = track_items.map { |item| item.attrs[:track_id] }

    # Delete locally stored tracks that are not remotely stored.
    (local_track_ids - remote_track_ids).each do |track_id|
      # Note we skip the callbacks
      Track.where(echo_nest_id: track_id).delete
    end

    # Delete remote tracks that are not stored locally
    Track.delete_from_taste_profile(taste_profile_id, remote_track_ids - local_track_ids)
  end
end
