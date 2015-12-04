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
      Track.decorate_with_favorited(params[:user_id], @station.id, @tracks)
    end

    render json: @tracks, root: "tracks"
  end
end
