require 'rails_helper'

RSpec.describe Station, type: :model do
  before { @station = FactoryGirl.build(:station) }

  subject { @station }

  it { should respond_to(:songs) }
  it { should respond_to(:name) }

  it { should be_valid }

  it { should validate_presence_of(:name) }

  it { should have_many(:songs) }

end
