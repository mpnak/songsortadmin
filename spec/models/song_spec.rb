require 'rails_helper'

RSpec.describe Song, type: :model do
  before { @song = FactoryGirl.build(:song) }

  subject { @song }

  it { should respond_to(:station) }
  it { should respond_to(:spotify_id) }
  it { should respond_to(:name) }
  it { should respond_to(:artist) }
  it { should respond_to(:undergroundness) }

  it { should be_valid }

  it { should validate_presence_of(:station) }
  it { should validate_presence_of(:spotify_id) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:artist) }

  it { should belong_to(:station) }


end
