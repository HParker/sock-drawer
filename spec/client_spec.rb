require 'spec_helper'
require 'logger'

RSpec.describe Sock::Drawer do
  let(:redis) { Redis.new }
  let(:sock) { Sock::Client.new(redis: redis, logger: Logger.new(nil)) }

  context '#pub' do
    it 'subscribes to events from redis with that name' do
      expect(redis).to receive(:publish).with('sock-hook/new_channel', 'hi')
      sock.pub('hi', postfix: 'new_channel')
    end
  end

  context '#sub' do
    let(:server) { Sock::Server.new }
    let(:hi_redis) { EM::Hiredis.connect }

    it 'can register a callback to be run when a event comes through redis' do
      steps :fire, :received
      sock.sub(server, 'hi') { |msg|
        expect(msg).to eq('hi there')
        complete :received
      }
      event_block do
        server.subscribe(server.name).callback do
          hi_redis.publish('sock-hook/hi', 'hi there').callback do
            complete :fire
          end
        end
      end
    end
  end
end
