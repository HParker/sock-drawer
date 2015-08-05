module Sock
  # server provides a EM process that will manage websocket connections
  class Server
    def initialize(name: DEFAULT_NAME,
                   logger: Logger.new(STDOUT),
                   socket_params: { host: HOST, port: PORT })
      @name = name
      @socket_params = socket_params
      @channels = {}
      @logger = logger
    end

    def start!
      EM.run do
        subscribe(@name)
        start_listening
      end
    end

    private

    def start_listening
      EventMachine::WebSocket.start(@socket_params) do |ws|
        handle_open(ws)
      end
    end

    def handle_open(ws)
      ws.onopen do |handshake|
        @logger.info "sock opened on #{handshake.path}"
        channel(@name + handshake.path).subscribe { |msg| ws.send(msg) }
        handle_close(ws)
      end
    end

    def handle_close(ws)
      ws.onclose { channel(@name + handshake.path).unsubscribe(sid) }
    end

    def subscribe(subscription)
      @logger.info "Subscribing to: #{subscription + '*'}"
      pubsub.psubscribe(subscription + '*') do |c, msg|
        @logger.info "pushing c: #{c} msg: #{msg}"
        channel(c).push(msg)
      end
    end

    def channel(channel_name)
      @logger.info "creating/finding channel #{channel_name}"
      @channels[channel_name] ||= EM::Channel.new
    end

    def pubsub
      @pubsub ||= EM::Hiredis.connect.pubsub
    end
  end
end
