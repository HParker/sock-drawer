require 'sock/drawer/version'
require 'em-websocket'
require 'em-hiredis'
require 'redis'
require 'logger'
require 'sock/client'
require 'sock/server'
require 'sock/subscriber'

# Sock is the top level module for sock objects
module Sock
  # the default prefix of events listened to on redis
  DEFAULT_NAME = 'sock-hook'
  # the default host to run the websocket server on
  HOST = '0.0.0.0'
  # the default port to run the websocket server on.
  PORT = 8020
end
