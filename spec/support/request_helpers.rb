module Request
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  # Our headers helpers module
  module HeadersHelpers
    def api_header(version = 1)
      #request.headers['Accept'] = "application/vnd.marketplace.v#{version}"
    end

    def api_response_format(format = Mime[:json])
      request.headers['Accept'] = "#{request.headers['Accept']},#{format}"
      request.headers['Content-Type'] = format.to_s
    end

    def include_default_accept_headers
      api_header
      api_response_format
    end
  end

  module AuthHelpers
    def basic_auth(user, password)
      credentials = ActionController::HttpAuthentication::Basic.encode_credentials user, password
      request.env['HTTP_AUTHORIZATION'] = credentials
    end

    def stationdose_auth
      basic_auth('doseadmin', 'bellyflop')
    end
  end
end

RSpec.configure do |config|
  config.include Request::JsonHelpers, type: :controller
  config.include Request::HeadersHelpers, type: :controller
  config.include Request::AuthHelpers, type: :controller
end

