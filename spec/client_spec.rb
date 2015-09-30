require 'spec_helper'
require 'logger'
require 'mock_class'

RSpec.describe Sock::Drawer do
  context '#pub' do
    let(:redis) { Redis.new }
    let(:sock) { Sock::Client.new(redis: redis, logger: Logger.new(nil)) }

    it 'subscribes to events from redis with that name' do
      expect(redis).to receive(:publish).with('sock-hook/new_channel', 'hi')
      sock.pub('hi', channel: 'new_channel')
    end
  end
end
