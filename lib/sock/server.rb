require 'json'

module Sock
  # server provides a EM process that will manage websocket connections
  class Server
    attr_reader :channels, :logger, :name
    def initialize(name: DEFAULT_NAME,
                   logger: Logger.new(STDOUT),
                   socket_params: { host: HOST, port: PORT },
                   mode: 'default',
                   listener: nil)
      @name = name
      @socket_params = socket_params
      @channels = {}
      @logger = logger
      @mode = mode
      @listener = listener
    end

    # utility method used to subscribe on the default name and start the socket server
    def start!
      EM.run do
        register! if @listener
        subscribe(@name)
        socket_start_listening
      end
    end

    # subscribe fires a event on a EM channel whenever a message is fired on a pattern matching `name`.
    # @name (default: "sock-hook/") + '*'
    def subscribe(subscription)
      @logger.info "Subscribing to: #{subscription + '*'}"
      pubsub.psubscribe(subscription + '*') do |chan, msg|
        @logger.info "pushing c: #{chan} msg: #{msg}"
        channel(chan).push(msg)
      end
    end

    # channel will find or create a EM channel.
    # channels can have new events pushed on them or subscribe to events from them.
    def channel(channel_name)
      @logger.info "creating channel #{channel_name}" unless @channels[channel_name]
      @channels[channel_name] ||= EM::Channel.new
    end

    # starts the websocket server
    # on open this server will find a new channel based on the path
    # on message it will fire an event to the default 'incoming-hook' channel.
    # on close, we do nothing. (future direction: would be nice to unsubscribe the websocket event if we know it is the only one listening to that channel)
    def socket_start_listening
      EventMachine::WebSocket.start(@socket_params) do |ws|
        handle_open(ws)
        handle_message(ws)
      end
    end

    def register!
      @listener.channels.each do |chan, block|
        subscribe(@name + '/' + chan)
        channel(@name + '/' + chan).subscribe { |msg|
          block.call(msg)
        }
      end
    end

    private

    def handle_open(ws)
      ws.onopen do |handshake|
        @logger.info "sock opened on #{handshake.path}"
        sid = channel(@name + handshake.path).subscribe { |msg| ws.send(msg) }
        handle_close(ws, sid, handshake)
      end
    end

    def handle_message(ws)
      ws.onmessage { |msg| channel('incoming-hook').push(msg) }
    end

    def handle_close(ws, sid, handshake)
      # TODO: how can I know the sid to remove this subscription?
      ws.onclose {
        @logger.info "connection #{sid} closed"
        channel(@name + handshake.path).unsubscribe(sid)
      }
    end

    def pubsub
      @pubsub ||= EM::Hiredis.connect.pubsub
    end
  end
end
