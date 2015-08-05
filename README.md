# Sock::Drawer

This gem acts to manage a set of websocket connections between a browser and a server.
It follows the reactor pattern. Events are fired and the client reads them.

This gem is a work in progress and does not yet have a way to respond to messages from the client.

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

publish an event on a channel

```Ruby

sock.pub("my message", postfix: "my-channel")

```

then in your javascript subscribe to the event

```javascript

var webSocket = new WebSocket("ws://" + location.hostname + ":8081/" + "my-channel");

webSocket.onmessage = function(event) {
  console.log(event.data);
}


```

And you are good to go!

:shipit:


## Contributing

1. Fork it ( https://github.com/[my-github-username]/sock-drawer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
