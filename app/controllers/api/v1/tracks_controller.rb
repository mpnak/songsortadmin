class Api::V1::TracksController < ApplicationController
  respond_to :json

  before_action :set_user
  before_action :set_playlist
  before_action :set_track

  def play
    respond_with @track
  end

  def skipped
    respond_with @track
  end

  def favorited
    respond_with @track
  end

  def banned
    respond_with @track
  end

  private

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_playlist
      @playlist = @user.playlists.find(params[:playlist_id])
    end

    def set_track
      @track = @playlist.find(params[:track_id])
    end
end
