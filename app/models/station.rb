class Station < ActiveRecord::Base
  has_many :tracks

  validates :name, presence: true

  before_create :create_taste_profile

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
end
