require 'rails_helper'

RSpec.describe "stations/show", type: :view do
  before(:each) do
    @station = assign(:station, FactoryGirl.create(:station, name: 'Name'))
    @tracks = []
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
