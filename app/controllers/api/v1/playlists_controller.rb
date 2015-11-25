class Api::V1::PlaylistsController < ApplicationController
  respond_to :json

  protect_from_forgery with: :null_session

  def index
    @user = User.find(params[:user_id])
    respond_with @user.playlists
  end

  def show
    @playlist =  Playlist.find(params[:id])
    respond_with @playlist
  end

  def create
    @playlist = Playlist.new(playlist_params)
    if @playlist.save
      @playlist.generate_tracks
      render json: @playlist, status: 201, location: [:api, @playlist]
    else
      render json: { errors: @playlist.errors }, status: 422
    end
  end

  def update
    @playlist = Playlist.find(params[:id])
    if @playlist.update(playlist_params)
      @playlist.generate_tracks
      render json: @playlist, status: 200, location: [:api, @playlist]
    else
      render json: { errors: playlist.errors }, status: 422
    end
  end

  def destroy
    playlist = Playlist.find(params[:id])
    playlist.destroy
    head 204
  end

  private
  def set_user
  end

  def playlist_params
    params.require(:playlist).permit(:user_id, :station_id, :undergroundness, :use_weather, :use_timeofday, :autoupdate)
  end

end
