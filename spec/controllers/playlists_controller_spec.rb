require 'rails_helper'

RSpec.describe Api::V1::PlaylistsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Track. As you add validations to Track, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    FactoryGirl.attributes_for(:playlist)
  }

  let(:invalid_attributes) {
    { invalid: true }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TracksController. Be sure to keep this updated too.
  let(:valid_session) do
    {}
  end

  describe "GET #show" do
      it "assigns a playlist as @playlist" do
        playlist = FactoryGirl.create(:playlist)
        get :show, id: playlist.to_param, format: :json
        expect(assigns(:playlist)).to be_a(Playlist)
      end
  end

  describe "POST #create" do

    before(:each) do
      @playlist = FactoryGirl.build(:playlist)
    end

    context "with valid params" do
      it "creates a new Playlist" do
        expect {
          post :create, {user_id: @playlist.user.id, playlist: @playlist.attributes}, valid_session

        }.to change(Playlist, :count).by(1)
      end

      it "assigns a newly created playlist as @playlist" do
        post :create, {user_id: @playlist.user.id, playlist: @playlist.attributes}, valid_session
        expect(assigns(:playlist)).to be_a(Playlist)
        expect(assigns(:playlist)).to be_persisted
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved playlist as @playlist" do
        post :create, {user_id: @playlist.user.id, playlist: invalid_attributes}, valid_session
        expect(assigns(:playlist)).to be_a_new(Playlist)
      end

      # it "re-renders the 'new' template" do
      #   post :create, {:track => invalid_attributes}, valid_session
      #   expect(response).to render_template("new")
      # end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { undergroundness: "4" }
      }

      it "updates the requested station" do
        playlist = FactoryGirl.create(:playlist)
        put :update, {:id => playlist.to_param, :playlist => new_attributes}, valid_session
        playlist.reload
        expect(playlist.undergroundness).to eq 4
      end

      it "assigns the requested playlist as @playlist" do
        playlist = FactoryGirl.create(:playlist)
        put :update, {:id => playlist.to_param, :playlist => new_attributes}, valid_session
        expect(assigns(:playlist)).to eq(playlist)
      end

    end

    context "with invalid params" do
      it "assigns the track as @playlist" do
        playlist = FactoryGirl.create(:playlist)
        put :update, {:id => playlist.to_param, :playlist => invalid_attributes}, valid_session
        expect(assigns(:playlist)).to eq(playlist)
      end

    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested playlist" do
      playlist = FactoryGirl.create(:playlist)
      expect {
        delete :destroy, {:id => playlist.to_param}, valid_session
      }.to change(Playlist, :count).by(-1)
    end
  end

end
