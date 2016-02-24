class Api::V1::TracksController < Api::V1::ApiController

  before_action :authenticate_with_token!

  def play
    @track = Track.find(params[:track_id])
    respond_with @track
  end

  def skipped
    @track = Track.find(params[:track_id])
    respond_with @track
  end

  def favorited
    @track_favorite = TrackFavorite.where(user_id: current_user.id, station_id: params[:station_id], track_id: params[:id]).first_or_initialize

    if @track_favorite.save
      render json: { success: true }
    else
      render json: { errors: @track_favorite.errors }, status: 422
    end
  end

  def unfavorited
    @track_favorite = TrackFavorite.where(user_id: current_user.id, station_id: params[:station_id], track_id: params[:id]).first

    if @track_favorite && @track_favorite.destroy
      head 204
    else
      head 422
    end
  end

  def banned
    if params[:saved_station_id]
      @saved_station = current_user.saved_stations.find(params[:saved_station_id])
      @saved_station_track = @saved_station.saved_station_tracks.where(track_id: params[:id]).first
      @saved_station_track.destroy if @saved_station_track
    end

    @track_ban = TrackBan.where(user_id: current_user.id, station_id: params[:station_id], track_id: params[:id]).first_or_initialize

    if @track_ban.save
      render json: { success: true }
    else
      render json: { errors: @track_ban.errors }, status: 422
    end
  end

end
