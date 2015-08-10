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

Initialize a instance of the sock client

```Ruby
sock = Sock::Client.new(logger: Rails.logger, redis: redis)
```

Publish an event on a channel,

```Ruby
sock.pub("my message", postfix: "my-channel")
```

Subscribe to events fired from a specific sock server,

```Ruby
sock.sub(server, "my-channel") do |message|
  puts message
end
```

To capture the event in Javascript use something like,

```javascript
var webSocket = new WebSocket("ws://" + location.hostname + ":8081/" + "my-channel");

webSocket.onmessage = function(event) {
  console.log(event.data);
}
```

If you wish to start the sock server in another thread you can use

    $ rake sock:server

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
