$:.unshift(File.expand_path("../lib", File.dirname(__FILE__)))

require "sock/drawer"
require 'mock_redis'

class MockRedis
  def publish(*args)
    true
  end

  def subscribe(*args)
    true
  end
end
