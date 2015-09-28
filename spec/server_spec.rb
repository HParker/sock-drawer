require 'spec_helper'
require 'em-websocket-client'
require 'json'

RSpec.describe Sock::Server do
  let(:server) { Sock::Server.new(logger: Logger.new(nil)) }
  let(:redis) { Redis.new }
  let(:hi_redis) { EM::Hiredis.connect }
  let(:sock) { Sock::Client.new(redis: redis, logger: Logger.new(nil)) }

  context '#subscribe' do
    it 'creates a channel for redis events to fire on' do
      steps :subscribe
      event_block do
        df = server.subscribe('my-sub')
        df.callback { |subs|
          expect(subs).to eq(1)
          complete :subscribe
        }
      end
    end

    it 'pushes an event onto a channel when a redis event is fired' do
      steps :fire
      event_block do
        server.subscribe('my-sub')
        df = hi_redis.publish('my-sub', 'hello')
        df.callback {
          expect(server.channels.keys).to eq(['my-sub'])
          complete :fire
        }
      end
    end

    it 'will not create another channel if one already exists' do
      steps :fire_1, :fire_2
      event_block do
        server.subscribe('my-sub')
        hi_redis.publish('my-sub', 'hello').callback {
          expect(server.channels.keys).to eq(['my-sub'])
          complete :fire_1

          hi_redis.publish('my-sub', 'goodbye').callback {
            expect(server.channels.keys).to eq(['my-sub'])
            complete :fire_2
          }
        }
      end
    end
  end

  context '#handle_register' do
    it 'subscribes to messages on DEFAULT_NAME + -channels and calls the code given' do
      steps :register, :create, :publish
      allow(Class).to receive(:new)
      event_block do
        server.handle_registers
        complete :register
        params = {
          file: Class.method(:new).source_location.first,
          class_name: 'Class',
          method: 'new',
          channel: 'my-sub'
        }
        hi_redis.publish(server.name + '-channels/', params.to_json).callback {
          expect(server.channels.keys).to eq(['sock-hook-channels/', 'my-sub'])
          complete :create
          hi_redis.publish('my-sub', '{}').callback {
            hi_redis.pubsub.subscribe('my-sub').callback {
              expect(Class).to have_received(:new)
              complete :publish
            }
          }
        }
      end
    end
  end

  context '#channel' do
    it 'finds or creates a channel' do
      server.channel('heyo')
      expect(server.channels.keys).to eq(['heyo'])
    end

    it 'prevents duplicates' do
      server.channel('heyo')
      server.channel('whatup')
      expect(server.channels.keys.sort).to eq(['heyo', 'whatup'].sort)
    end

    it 'can have events attached to it' do
      steps :subscribe
      event_block do
        server.channel('9 news').subscribe { |msg|
          expect(msg).to eq('hello there')
          complete :subscribe
        }
        server.channel('9 news').push("hello there")
      end
    end
  end

  context '#socket_start_listening' do
    let(:conn) { EventMachine::WebSocketClient.connect("ws://0.0.0.0:8020/") }

    it 'subscribes to a channel when a connection opens' do
      steps :open
      event_block do
        server.socket_start_listening
        EventMachine::WebSocketClient.connect("ws://0.0.0.0:8020/").callback do
          expect(server.channels.keys).to eq(['sock-hook/'])
          complete :open
        end
      end
    end

    it 'opens different channels for different routes' do
      steps :open
      event_block do
        server.socket_start_listening
        EventMachine::WebSocketClient.connect("ws://0.0.0.0:8020/hi").callback do
          expect(server.channels.keys).to eq(['sock-hook/hi'])
          complete :open
        end
      end
    end

    it 'sends whatever message is sent across the channel' do
      steps :open, :receive
      event_block do
        server.socket_start_listening
        conn.callback do
          server.channels['sock-hook/'].push('What up')
          complete :open
        end

        conn.stream do |msg|
          expect(msg.data).to eq('What up')
          complete :receive
        end
      end
    end

    it 'will send incoming webhooks to a channel' do
      steps :open, :receive
      event_block do
        server.socket_start_listening
        conn.callback do
          conn.send_msg('LGTM')
          complete :open
          server.channel('incoming-hook').subscribe { |msg|
            expect(msg).to eq('LGTM')
            complete :receive
          }
        end
      end
    end

    it 'does nothing on close yet' do
      # TODO: unsub sid
    end
  end
end
