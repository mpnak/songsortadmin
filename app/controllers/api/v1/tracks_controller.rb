class Api::V1::TracksController < ApplicationController
  respond_to :json

  protect_from_forgery with: :null_session

  def play
    respond_with @track
  end

  def skipped
    respond_with @track
  end

  def favorited
    respond_with @track
  end

  def banned
    if params[:saved_station_id]
      @saved_station = SavedStation.find(params[:saved_station_id])
      @saved_station_track = @saved_station.saved_station_tracks.where(track_id: params[:id]).first
      @saved_station_track.destroy if @saved_station_track
    end

    @track_ban = TrackBan.where(user_id: params[:user_id], station_id: params[:station_id], track_id: params[:id]).first_or_initialize

    if @track_ban.save
      render json: { success: true }
    else
      render json: { errors: @track_ban.errors }, status: 422
    end
  end

  private

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_station
      @station = Station.find(params[:station_id])
    end

    def set_track
      @track = Track.find(params[:track_id])
    end
end
