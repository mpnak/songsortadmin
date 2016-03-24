class User < ActiveRecord::Base
  #has_many :saved_stations
  has_many :track_bans
  has_many :track_favorites
  has_many :user_station_links


  # Find or create a user from an omniauth hash
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.generate_authentication_token!
    end
  end

  def self.from_spotify_id(uid)
    provider = "spotify"

    where(provider: provider, uid: uid).first_or_create do |user|
      user.generate_authentication_token!
    end
  end

  def generate_authentication_token!
    begin
      self.auth_token = SecureRandom.base64(20)
    end while self.class.exists?(auth_token: auth_token)
  end

end
