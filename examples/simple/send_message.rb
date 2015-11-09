require_relative '../../lib/sock/drawer'

Sock::Client.new.pub(ARGV.first, channel: 'my-channel')
