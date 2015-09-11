Echowrap.configure do |config|
  config.api_key =       Figaro.env.echo_nest_api_key
  config.consumer_key =  Figaro.env.echo_nest_consumer_key
  config.shared_secret = Figaro.env.echo_nest_shared_secret
end
