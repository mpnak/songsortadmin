require 'rails_helper'

RSpec.describe Playlist, type: :model do
  before { @playlist = FactoryGirl.build(:playlist) }

  subject { @playlist }

  it { should respond_to(:user) }
  it { should respond_to(:tracks) }

  it "should have associated tracks" do
    playlist = FactoryGirl.create(:playlist)
    track1 = FactoryGirl.create(:track)
    track2 = FactoryGirl.create(:track)
    playlist.tracks << track1
    playlist.tracks << track2

    expect(playlist.tracks.count).to be 2
  end
end
