require 'spec_helper'
require 'logger'

RSpec.describe Sock::Drawer do
  let(:redis) { MockRedis.new }
  let(:sock) { Sock::Client.new(redis: redis, logger: Logger.new(nil)) }

  it 'subscribes to events from redis with that name' do
    expect(redis).to receive(:publish).with('sock-hook/new_channel', 'hi')
    sock.pub('hi', postfix: 'new_channel')
  end

  it 'can register a callback to be run when a event comes through redis' do

  end
end
