#!/usr/bin/env ruby
$:<< '../lib' << 'lib'

require 'goliath'
require 'goliath/plugins/latency'

require 'yajl'

class Float
  def bytesize
    to_s.bytesize
  end
end


class PulseTemp < Goliath::API
  use Goliath::Rack::DefaultMimeType    # cleanup accepted media types
  use Goliath::Rack::Render, 'json'     # auto-negotiate response format
  use Goliath::Rack::Params             # parse & merge query and body parameters
  use Goliath::Rack::Heartbeat          # respond to /status with 200, OK (monitoring, etc)

  use Goliath::Rack::Validation::RequestMethod, %w(GET POST)           # allow GET and POST requests only
  #plugin Goliath::Plugin::Latency       # output reactor latency every second

  def response(env)
    case (env[Goliath::Request::REQUEST_METHOD])
    when 'GET'
      temps = redis.lrange("recent_temps", 0, -1).map &:to_f
      [200, {}, temps.first]
    when 'POST'
      temp = params[:current_temp].to_f
      if temp < 150
        redis.lpush("recent_temps", temp)
        redis.ltrim("recent_temps", 0, 99)
      end
      [200, {}, "OK"]
    else
      [404, {}, "FFFFFFFUUUUUUUUUUU"]
    end
  end

end
