class TracksController < ApplicationController

  def create
    @station = Station.find(track_params[:station_id])

    @track = Track.build_from_spotify_id(track_params[:spotify_id])
    @track.station = @station

    if @track.save
      render json: @track, status: 201, location: @track
    else
      render json: { errors: @track.errors }, status: 422
    end
  end

  private
  def track_params
    params.require(:track).permit(:spotify_id, :station_id)
  end

end
