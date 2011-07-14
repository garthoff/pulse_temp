require 'em-synchrony/em-redis' 

redis_uri = URI.parse( ENV["REDISTOGO_URL"] || "redis://localhost:6379" )
config['redis'] ||= EM::Protocols::Redis.connect(:host => redis_uri.host, :port => redis_uri.port, :password => redis_uri.password)

