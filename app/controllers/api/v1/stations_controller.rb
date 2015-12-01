class Api::V1::StationsController < ApplicationController
  respond_to :json

  #before_action :authenticate_with_token!, only: [:create, :update]

  def index
    @stations = Station.from_params(params)
    respond_with @stations
  end

  def show
    respond_with Station.find(params[:id])
  end
end
