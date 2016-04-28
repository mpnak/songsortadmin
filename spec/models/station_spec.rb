require 'rails_helper'

RSpec.describe Station, type: :model do
  before { @station = FactoryGirl.build(:station) }

  subject { @station }

  it { should respond_to(:tracks) }
  it { should respond_to(:name) }
  it { should be_valid }
  it { should validate_presence_of(:name) }
  it { should have_many(:tracks) }

  it "should come with some tracks" do
    station = FactoryGirl.create :station
    expect(station.tracks.count).to be > 0
  end

  describe "#generate_tracks" do
    it "should generate some tracks" do
      station = FactoryGirl.create :station

      tracks = station.generate_tracks

      expect(tracks.count).to be > 0
    end

  end

end
