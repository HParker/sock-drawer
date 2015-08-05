require 'sock/drawer/version'
require 'em-websocket'
require 'em-hiredis'
require 'redis'
require 'logger'
require 'sock/client'
require 'sock/server'

# Sock is the top level module for sock objects
module Sock
  DEFAULT_NAME = 'sock-hook'
  HOST = '0.0.0.0'
  PORT = 8020
end
