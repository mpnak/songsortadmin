class TracksController < ApplicationController
  before_action :set_track, only: [:update, :destroy]

  def create
    @station = Station.find(track_params[:station_id])

    @track = @station.tracks.build_from_spotify_id(track_params[:spotify_id])

    if @track.save
      render partial: 'track', locals: { track: @track }
    else
      head :bad_request
    end
  end

  def update
    @track = Track.find(params[:id])

    if @track.update(track_update_params)
      render json: @track, status: 201, location: @track
    else
      render json: { errors: @track.errors }, status: 422
    end
  end

  def destroy
    @track = Track.find(params[:id])

    if @track.destroy
      head :no_content
    else
      head :bad_request
    end
  end

  private
  def set_track
  end

  def track_params
    params.require(:track).permit(:spotify_id, :station_id)
  end

  def track_update_params
    params.require(:track).permit(:undergroundness)
  end

end
