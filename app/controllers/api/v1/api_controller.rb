class Api::V1::ApiController < ActionController::API
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session

  after_action do
    begin
      if request.format.json? && response
        puts "response:"
        ap JSON.parse(response.body)
      end
    rescue
    end
  end

  # Devise methods overwrites
  def bearer_token
    pattern = /^Bearer /
    header  = request.headers["Authorization"]
    header.gsub(pattern, "") if header && header.match(pattern)
  end

  def current_user
    @current_user ||= User.find_by(auth_token: bearer_token)
  end

  def authenticate_with_token!
    return if user_signed_in?

    render json: { errors: "Not authenticated" }, status: :unauthorized
  end

  def user_signed_in?
    current_user.present?
  end
end
