class Api::V1::UsersController < ApplicationController
  respond_to :json

  #before_action :authenticate_with_token!, only: [:create, :update]

  def index
    respond_with User.all
  end

  def show
    respond_with User.find(params[:id])
  end
end
