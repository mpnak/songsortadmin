require 'rails_helper'

RSpec.describe Station, type: :model do
  before { @station = FactoryGirl.build(:station) }

  subject { @station }

  it { should respond_to(:tracks) }
  it { should respond_to(:name) }
  it { should respond_to(:taste_profile_id) }
  it { should respond_to(:taste_profile) }

  it { should be_valid }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:taste_profile_id) }

  it { should have_many(:tracks) }

end
