class Api::V1::SavedStationsController < ApplicationController
  respond_to :json

  protect_from_forgery with: :null_session

  def index
    @user = User.find(params[:user_id])
    respond_with @user.saved_stations
  end

  def show
    @saved_station =  SavedStation.find(params[:id])
    respond_with @saved_station
  end

  def create
    @saved_station = SavedStation.new(saved_station_params)
    if @saved_station.save
      @saved_station.generate_tracks
      render json: @saved_station, status: 201, location: [:api, @saved_station]
    else
      render json: { errors: @saved_station.errors }, status: 422
    end
  end

  def update
    @saved_station = SavedStation.find(params[:id])
    if @saved_station.update(saved_station_params)
      @saved_station.generate_tracks
      render json: @saved_station, status: 200, location: [:api, @saved_station]
    else
      render json: { errors: saved_station.errors }, status: 422
    end
  end

  def destroy
    saved_station = SavedStation.find(params[:id])
    saved_station.destroy
    head 204
  end

  def generate_tracks
    @saved_station = SavedStation.find(params[:id])
    @tracks = @saved_station.generate_tracks

    if params[:user_id]
      Track.decorate_with_favorited(params[:user_id], @saved_station.station_id, @tracks)
    end

    render json: @tracks, root: "tracks", meta: { updated_at: @saved_station.updated_at }
  end

  def tracks
    @saved_station = SavedStation.find(params[:id])
    @tracks = @saved_station.tracks

    if params[:user_id]
      Track.decorate_with_favorited(params[:user_id], @saved_station.station_id, @tracks)
    end

    render json: @tracks, root: "tracks", meta: { updated_at: @saved_station.updated_at }
  end

  private
  def set_user
  end

  def saved_station_params
    params.require(:saved_station).permit(:user_id, :station_id, :undergroundness, :use_weather, :use_timeofday, :autoupdate)
  end

end
