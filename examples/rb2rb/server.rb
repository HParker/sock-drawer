require 'sock/drawer'
class MyListener
  include Sock::Subscriber

  on 'my-channel' do |msg|
    puts '--------------------'
    puts msg
    puts '--------------------'
  end
end

Sock::Server.new(listener: MyListener).start!
