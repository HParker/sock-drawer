module Sock
  # Client is the interface for publishing events to Drawer
  class Client
    def initialize(name: DEFAULT_NAME,
                   logger: Logger.new(STDOUT),
                   redis: Redis.new)
      @logger = logger
      @name = name
      @redis = redis
    end

    def pub(msg, postfix: '')
      @logger.info "sending #{msg} on channel: #{channel_name(postfix)}"
      @redis.publish(channel_name(postfix), msg)
    end

    def sub(server, channel, &block)
      @logger.info "subscribing to #{channel}"
      server.channel(channel_name(channel)).subscribe { |msg| block.call(msg) }
    end

    private

    def channel_name(postfix)
      "#{@name}/#{postfix}"
    end
  end
end
