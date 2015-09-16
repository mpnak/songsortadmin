class TracksController < ApplicationController
  before_action :set_track, only: [:update]

  def create
    @station = Station.find(track_params[:station_id])

    @track = @station.tracks.build_from_spotify_id(track_params[:spotify_id])

    if @track.save
      render partial: 'track', locals: { track: @track }
      #render json: @track, status: 201, location: @track
    else
      #render json: { errors: @track.errors }, status: 422
      ap @track.errors
      head :bad_request
    end
  end

  def update
    if @track.update(track_update_params)
      render json: @track, status: 201, location: @track
    else
      render json: { errors: @track.errors }, status: 422
    end
  end

  private
  def set_track
    @track = Track.find(params[:id])
  end

  def track_params
    params.require(:track).permit(:spotify_id, :station_id)
  end

  def track_update_params
    params.require(:track).permit(:undergroundness)
  end

end
