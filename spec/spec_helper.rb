$LOAD_PATH.unshift(File.expand_path('../lib', File.dirname(__FILE__)))

require 'sock/drawer'
require 'pry'

def event_block
  Timeout::timeout(5) do
    EM.run do
      EM.epoll
      yield
    end
  end
rescue Timeout::Error
  fail "Eventmachine was not stopped with #{@_em_steps} left"
end

def steps(*steps)
  @_em_steps = *steps
end

def complete(step)
  @_em_steps.delete(step)
  EM.stop if @_em_steps.empty?
end
