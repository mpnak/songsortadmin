require 'rails_helper'

RSpec.describe "stations/index", type: :view do
  before(:each) do
    assign(:stations, [
      Station.create!(
        :name => "Name"
      ),
      Station.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of stations" do
    render
    assert_select "div.station-content", :text => "Name".to_s, :count => 2
  end
end
