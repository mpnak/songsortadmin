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

  it { should be_valid }

  it { should validate_presence_of(:station) }
  it { should validate_presence_of(:spotify_id) }
  it { should validate_presence_of(:echo_nest_id) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:artist) }

  it { should belong_to(:station) }


end
