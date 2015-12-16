class Api::V1::StationsController < ApplicationController
  respond_to :json

  protect_from_forgery with: :null_session

  #before_action :authenticate_with_token!, only: [:create, :update]

  def index
    @stations = Station.from_params(params)
    respond_with @stations
  end

  def show
    respond_with Station.find(params[:id])
  end

  def generate_tracks
    @station = Station.find(params[:id])
    @tracks = @station.generate_tracks

    if params[:user_id]
      # Cache the tracks so we can GET them
      user_station_link = @station.user_station_links.where(user_id: params[:user_id]).first_or_initialize

      user_station_link.tracks = @tracks
      user_station_link.save

      # Add favorited flag
      Track.decorate_with_favorited(params[:user_id], @station.id, @tracks)

    end

    render json: @tracks, root: "tracks"
  end

  def get_tracks
    @station = Station.find(params[:id])

    @tracks = if params[:user_id] &&
      (user_station_link = @station.user_station_links.where(user_id: params[:user_id]).first)

      tracks = user_station_link.tracks
      Track.decorate_with_favorited(params[:user_id], @station.id, tracks)
      tracks
    else
      []
    end

    render json: @tracks, root: "tracks"
  end
end
