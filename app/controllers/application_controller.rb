class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate

  def authenticate
    unless request.format.json?
      authenticate_or_request_with_http_basic('Administration') do |username, password|
        username == 'doseadmin' && password == 'bellyflop'
      end
    end
  end

  after_filter do
    begin
      if request.format.json? && response
        puts "response:"
        ap JSON.parse(response.body)
      end
    rescue
    end
  end

end
