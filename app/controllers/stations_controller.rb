class StationsController < ApplicationController
  before_action :set_station, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @stations = Station.all
    respond_with(@stations)
  end

  def show
    respond_with(@station)
  end

  def new
    @station = Station.new
    respond_with(@station)
  end

  def edit
  end

  def create
    @station = Station.new(station_params)
    @station.save
    respond_with(@station)
  end

  def update
    @station.update(station_params)
    respond_with(@station)
  end

  def destroy
    @station.destroy
    respond_with(@station)
  end

  private
    def set_station
      @station = Station.find(params[:id])
    end

    def station_params
      params.require(:station).permit(:name)
    end
end