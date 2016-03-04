class Api::V1::StationsController < Api::V1::ApiController

  #before_action :authenticate_with_token!, only: [:generate_tracks, :get_tracks]

  def index
    @stations = Station.from_params(params)
    respond_with @stations
  end

  def show
    respond_with Station.find(params[:id])
  end

  def generate_tracks
    @station = Station.find(params[:id])

    @tracks = @station.generate_tracks({ ll: params[:ll] })

    if current_user
      # Cache the tracks so we can GET them
      user_station_link = @station.user_station_links.where(user_id: current_user.id).first_or_initialize

      user_station_link.tracks = @tracks
      user_station_link.save

      # Add favorited flag
      Track.decorate_with_favorited(current_user.id, @station.id, @tracks)
    end

    render json: @tracks, root: "tracks"
  end

  def get_tracks
    @station = Station.find(params[:id])

    @tracks = if current_user &&
        (user_station_link = @station.user_station_links.where(user_id: current_user.id).first)

      tracks = user_station_link.tracks
      Track.decorate_with_favorited(current_user.id, @station.id, tracks)
      tracks
    else
      []
    end

    render json: @tracks, root: "tracks"
  end
end
