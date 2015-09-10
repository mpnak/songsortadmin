require 'rails_helper'

RSpec.describe "Stations", type: :request do

  def auth_headers(user, password)
      {
        'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(user, password)
      }
  end

  describe "GET /stations" do
    it "works! (now write some real specs)" do
      get stations_path, {}, auth_headers("user", "password")
      expect(response).to have_http_status(200)
    end
  end
end
