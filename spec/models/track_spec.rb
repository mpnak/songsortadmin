require 'rails_helper'

RSpec.describe Track, type: :model do
  before { @track = FactoryGirl.build(:track) }

  subject { @track }

  it { should respond_to(:station) }
  it { should respond_to(:spotify_id) }
  it { should respond_to(:echo_nest_id) }
  it { should respond_to(:title) }
  it { should respond_to(:artist) }
  it { should respond_to(:undergroundness) }
  it { should respond_to(:playlists) }

  it { should be_valid }

  it { should validate_presence_of(:station) }
  it { should validate_presence_of(:spotify_id) }
  it { should validate_presence_of(:echo_nest_id) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:artist) }

  it { should belong_to(:station) }

  describe "::build_from_spotify_id" do
    it "should build a track" do
      @track = Track.build_from_spotify_id("0ng5s1sqaQ3K0NhMDN7WSL")

      expect(@track.title).to eq "No Ordinary Herb"
      expect(@track.artist).to eq "Fantan Mojah"
      expect(@track.echo_nest_id).to eq "TRXBCDF144D0B19694"
      expect(@track.spotify_id).to eq "0ng5s1sqaQ3K0NhMDN7WSL"
    end
  end
end
