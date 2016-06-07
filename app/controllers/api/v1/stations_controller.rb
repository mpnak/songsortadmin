class Api::V1::StationsController < Api::V1::ApiController

  before_action :authenticate_with_token!, only: [:update]

  def index
    @stations = Station.from_params(params, current_user)
    respond_with @stations
  end

  def show
    respond_with Station.find_with_user(params[:id], current_user)
  end

  def playlist_profile_chooser
    playlist_profile_chooser = PlaylistProfileChooser.new(params)
    render json: playlist_profile_chooser
  end

  def generate_tracks
    @station = Station.find_with_user!(params[:id], current_user)

    tracks = @station.generate_tracks({ ll: params[:ll] })
    @station.generated_tracks = tracks

    # Update users undergroundness setting if needed. For the moment, we assume
    # success and don't bother with error responses
    if (@user_station_link = @station.user_station_link) && params[:undergroundness]
      @user_station_link.update(undergroundness: params[:undergroundness])
    end

    render json: @station, serializer: StationWithTracksSerializer
  end

  def get_tracks
    @station = Station.find_with_user(params[:id], current_user)

    tracks = if @station.user_station_link
                @station.user_station_link.tracks_with_user_info
              else
                []
              end

    @station.generated_tracks = tracks

    render json: @station, serializer: StationWithTracksSerializer
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
    params.require(:station).permit(:undergroundness, :saved_station)
  end
end
