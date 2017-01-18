class StationsController < ApplicationController
  before_action :set_station, only: [:show, :edit, :update, :destroy]

  def index
    @stations = Station.from_params(params.merge(inactive: true))
  end

  def show
    gon.push(station_id: @station.id)
    @tracks = @station.tracks.order(created_at: :desc)
  end

  def new
    @station = Station.new
  end

  def create
    @station = Station.new(station_params)
    @station.save
  end

  def update
    @station.touch
    @station.update(station_params)
    redirect_to station_path(@station)
  end

  def destroy
    @station.destroy
  end

  private

    def set_station
      @station = Station.find(params[:id])
    end

    def station_params
      params
        .require(:station)
        .permit(
          :name,
          :short_description,
          :station_type,
          :url,
          :station_art,
          :active
        )
    end
end
