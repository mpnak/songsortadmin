# class Api::V1::SavedStationsController < Api::V1::ApiController
#   before_action :authenticate_with_token!
#
#   def index
#     respond_with current_user.saved_stations
#   end
#
#   def show
#     @saved_station =  current_user.saved_stations.find(params[:id])
#     respond_with @saved_station
#   end
#
#   def create
#     @saved_station = current_user.saved_stations.new(saved_station_params)
#     if @saved_station.save
#       @saved_station.generate_tracks
#       render json: @saved_station, status: 201, location: [:api, @saved_station]
#     else
#       render json: { errors: @saved_station.errors }, status: 422
#     end
#   end
#
#   def update
#     @saved_station =  current_user.saved_stations.find(params[:id])
#     if @saved_station.update(saved_station_params)
#       @saved_station.generate_tracks
#       render json: @saved_station, status: 200, location: [:api, @saved_station]
#     else
#       render json: { errors: saved_station.errors }, status: 422
#     end
#   end
#
#   def destroy
#     saved_station = current_user.saved_stations.find(params[:id])
#     saved_station.destroy
#     head 204
#   end
#
#   def generate_tracks
#     @saved_station = current_user.saved_stations.find(params[:id])
#     @tracks = @saved_station.generate_tracks({ ll: params[:ll] })
#     Track.decorate_with_favorited(current_user.id, @saved_station.station_id, @tracks)
#
#     render json: @tracks, root: "tracks", meta: { updated_at: @saved_station.updated_at }
#   end
#
#   def tracks
#     @saved_station = current_user.saved_stations.find(params[:id])
#     @tracks = @saved_station.tracks
#     Track.decorate_with_favorited(current_user.id, @saved_station.station_id, @tracks)
#
#     render json: @tracks, root: "tracks", meta: { updated_at: @saved_station.updated_at }
#   end
#
#   private
#   def set_user
#   end
#
#   def saved_station_params
#     params.require(:saved_station).permit(:station_id, :undergroundness, :use_weather, :use_timeofday, :autoupdate)
#   end
#
# end
