class TracksController < ApplicationController
  before_action :set_station, only: [:create]

  def create
    track = Echowrap.track_profile(:id => "spotify:track:#{params["spotify_id"]}")

    if track && @station
      track = Song.create({
        title: track["title"],
        spotify_id: params["spotify_id"],
        echo_nest_id: track["id"]
      })
    end

    if track && track.save
      render json: track, status: 201, location: track
    else
      render json: { errors: track.errors }, status: 422
    end

  end

  private
  def track_params
    params.require(:station).permit(:spotify_id, :station_id)
  end

  def set_station
    @station = Station.find(params[:station_id])
  end

end
