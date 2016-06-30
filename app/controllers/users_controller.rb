class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @stations = Station.all
  end

  def station
    @user = User.find(params[:id])
    @station = Station.find_with_user!(params[:station_id], params[:id])
    @link = @station.user_station_link
    @playlist = @link.playlist
  end
end
