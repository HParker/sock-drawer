# Sock::Drawer

This gem allows message async message calls to subscribed listeners.
Messages can be fired between ruby objects or to websocket connections.

[![Circle CI](https://circleci.com/gh/HParker/sock-drawer.svg?style=svg)](https://circleci.com/gh/HParker/sock-drawer)
[![Code Climate](https://codeclimate.com/github/HParker/sock-drawer/badges/gpa.svg)](https://codeclimate.com/github/HParker/sock-drawer)
[![Test Coverage](https://codeclimate.com/github/HParker/sock-drawer/badges/coverage.svg)](https://codeclimate.com/github/HParker/sock-drawer/coverage)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sock-drawer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sock-drawer

## Usage

Initialize a instance of the sock-drawer client

```Ruby
sock = Sock::Client.new(logger: Rails.logger, redis: redis)
```

### Publishing

Publish an event on a channel,

```Ruby
sock.pub("my message", channel: "my-channel")
```

or publish to all channels,

```Ruby
sock.pub("my message")
```

### Receiving in Javascript

To capture the event in Javascript use something like,

```javascript
var webSocket = new WebSocket("ws://" + location.hostname + ":8081/" + "my-channel");

webSocket.onmessage = function(event) {
  console.log(event.data);
}
```

### Subscribing

Create a class to handle redis events like,

```Ruby
class MyListener
  include Sock::Subscriber

  on 'echo' do |msg|
    msg
  end
end
```

Then register your listener with the server

```Ruby
Sock::Server.new(listener: MyListener)
```

Whenever an event is fired on the `sock-hook/echo` channel the block will be executed.


### Configuration

you can configure your sock server to run as a rake task like,

```Ruby
namespace :sock do
  desc 'start the sock-drawer server to manage socket connections'
  task :server do
    Sock::Server.new.start!
  end
end
```

Then run it with `rake sock:server`
Current supported configuration options:

| keyword arg | default |
| ----------- | ------- |
| name | 'sock-hook' |
| logger | Logger.new(STDOUT) |
| socket_params | { host: '0.0.0.0', port: 8020 } |
| mode | 'default' |
| listener | N/A |

## Wish List

- Right now all configuration is passed into new, it would be nice to read from a config file
- There isn't a way of having multiple event handlers. Should be easy to pass multiple in or intelligently find them (given some convention)

And you are good to go!

## Contributing

1. Fork it ( https://github.com/[my-github-username]/sock-drawer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Running the tests

if you are going to contribute, I hope you run the tests at least once -- hopefully many times.
to run the tests, you must have redis-server running in the background with default configuration.
