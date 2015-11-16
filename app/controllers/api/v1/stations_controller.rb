class Api::V1::StationsController < ApplicationController
  respond_to :json

  #before_action :authenticate_with_token!, only: [:create, :update]

  def index
    respond_with Station.all
  end

  def show
    respond_with Station.find(params[:id])
  end
end
