module Sock
  # server provides a EM process that will manage websocket connections
  class Server
    attr_reader :channels, :logger, :name
    def initialize(name: DEFAULT_NAME,
                   logger: Logger.new(STDOUT),
                   socket_params: { host: HOST, port: PORT },
                   mode: 'default')
      @name = name
      @socket_params = socket_params
      @channels = {}
      @logger = logger
      @mode = mode
    end

    def start!
      EM.run do
        subscribe(@name)
        socket_start_listening
      end
    end

    def subscribe(subscription)
      @logger.info "Subscribing to: #{subscription + '*'}"
      pubsub.psubscribe(subscription + '*') do |chan, msg|
        @logger.info "pushing c: #{chan} msg: #{msg}"
        channel(chan).push(msg)
      end
    end

    def channel(channel_name)
      @logger.info "creating/finding channel #{channel_name}"
      @channels[channel_name] ||= EM::Channel.new
    end

    def socket_start_listening
      EventMachine::WebSocket.start(@socket_params) do |ws|
        handle_open(ws)
        handle_message(ws)
        handle_close(ws)
      end
    end

    private

    def handle_open(ws)
      ws.onopen do |handshake|
        @logger.info "sock opened on #{handshake.path}"
        channel(@name + handshake.path).subscribe { |msg| ws.send(msg) }
      end
    end

    def handle_message(ws)
      ws.onmessage { |msg| channel('incoming-hook').push(msg) }
    end

    def handle_close(ws)
      # TODO: how can I know the sid to remove this subscription?
      ws.onclose {
        @logger.info "connection closed"
        # channel(@name + handshake.path).unsubscribe(sid)
      }
    end

    def pubsub
      @pubsub ||= EM::Hiredis.connect.pubsub
    end
  end
end
