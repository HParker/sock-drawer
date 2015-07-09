require 'spec_helper'

RSpec.describe Sock::Drawer do
  it "takes a name on initialize" do
    Sock::Client.new
    Sock::Client.new('sock-you')
  end

  it "subscribes to events from redis with that name" do

  end
end
