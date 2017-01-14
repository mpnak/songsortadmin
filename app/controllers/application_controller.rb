class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate

  def authenticate
    return if request.format.json?

    authenticate_or_request_with_http_basic("Administration") do |username, password|
      username == "doseadmin" && password == "bellyflop"
    end
  end
end
