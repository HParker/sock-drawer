require 'spec_helper'
require 'logger'
require 'mock_class'

RSpec.describe Sock::Drawer do
  context '#pub' do
    let(:redis) { Redis.new }
    let(:sock) { Sock::Client.new(redis: redis, logger: Logger.new(nil)) }

    it 'subscribes to events from redis with that name' do
      expect(redis).to receive(:publish).with('sock-hook/new_channel', 'hi')
      sock.pub('hi', postfix: 'new_channel')
    end
  end

  context '#sub' do
    let(:server) { Sock::Server.new(logger: Logger.new(nil)) }
    let(:hi_redis) { EM::Hiredis.connect }
    let(:sock) { Sock::Client.new(redis: hi_redis, logger: Logger.new(nil)) }

    it 'can register a callback to be run when a event comes through redis', :focus => true do
      steps :listen, :fire
      allow(Foo).to receive(:bar)
      event_block do
        server.handle_registers
        hi_redis.pubsub.subscribe('sock-hook-channels/') { |args|
          complete :listen
          hi_redis.publish('sock-hook/hi', 'hi there').callback {
            sleep 1
            expect(Foo).to have_received(:bar)
            complete :fire
          }
        }
        Foo.new.subscribe_do_bar
      end
    end
  end
end
