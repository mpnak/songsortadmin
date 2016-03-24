class Api::V1::StationsController < Api::V1::ApiController

  before_action :authenticate_with_token!, only: [:update]

  def index
    @stations = Station.from_params(params, current_user)
    respond_with @stations
  end

  def show
    respond_with Station.find_with_user(params[:id], current_user)
  end

  def generate_tracks
    @station = Station.find_with_user!(params[:id], current_user)

    @tracks = @station.generate_tracks({ ll: params[:ll]})

    render json: @tracks, root: "tracks"
  end

  def get_tracks
    @station = Station.find_with_user(params[:id], current_user)

    @tracks = if @station.user_station_link
                @station.user_station_link.tracks_with_user_info
              else
                []
              end

    render json: @tracks, root: "tracks"
  end


  def update
    @station = Station.find_with_user!(params[:id], current_user)

    @user_station_link = @station.user_station_link

    if @user_station_link.update(station_params)
      # TODO FIXME need to supply a ll here or get the client side to make
      # another request
      #@user_station_link.station.generate_tracks({user: current_user})
      render json: @user_station_link.station, status: 200
    else
      render json: { errors: @user_station_link.errors }, status: 422
    end
  end

  private

  def station_params
    params.require(:station).permit(:undergroundness, :use_weather, :use_timeofday)
  end
end
