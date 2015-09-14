require 'rails_helper'

RSpec.describe TracksController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Track. As you add validations to Track, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:spotify_id) { "0ng5s1sqaQ3K0NhMDN7WSL" }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TracksController. Be sure to keep this updated too.
  let(:valid_session) do
    {}
  end

  describe "POST #create" do

    before(:each) do
      @station = FactoryGirl.create(:station)
    end

    context "with valid params" do
      it "creates a new Track" do
        expect {
          post :create, {:track => {spotify_id: spotify_id, station_id: @station.id} }, valid_session
        }.to change(Track, :count).by(1)
      end

      it "assigns a newly created track as @track" do
        post :create, {:track => {spotify_id: spotify_id, station_id: @station.id} }, valid_session
        expect(assigns(:track)).to be_a(Track)
        expect(assigns(:track)).to be_persisted
      end

      # it "redirects to the created track" do
      #   post :create, {:track => valid_attributes}, valid_session
      #   expect(response).to redirect_to(Track.last)
      # end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved track as @track" do
        post :create, {:track => invalid_attributes}, valid_session
        expect(assigns(:track)).to be_a_new(Track)
      end

      # it "re-renders the 'new' template" do
      #   post :create, {:track => invalid_attributes}, valid_session
      #   expect(response).to render_template("new")
      # end
    end
  end

end
