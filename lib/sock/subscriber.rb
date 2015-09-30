module Sock
  # module for catching events fired from redis
  module Subscriber
    def self.included(base)
      base.extend(SubscriberDSL)
    end

    module SubscriberDSL
      def on(channel, &block)
        channels[channel] = block
      end

      def channels
        @_channels ||= {}
      end
    end
  end
end
