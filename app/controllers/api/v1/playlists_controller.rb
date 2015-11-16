class Api::V1::PlaylistsController < ApplicationController
  respond_to :json

  before_action :set_user

  def index
    respond_with @user.playlists
  end

  def show
    respond_with @user.playlists.find(params[:id])
  end

  private

    def set_user
      @user = User.find(params[:user_id])
    end
end
