$LOAD_PATH.unshift(File.expand_path('../lib', File.dirname(__FILE__)))

require 'sock/drawer'
require 'mock_redis'

# mock redis munkey patch to allow pub/sub
class MockRedis
  def publish(*)
    true
  end

  def subscribe(*)
    true
  end
end
