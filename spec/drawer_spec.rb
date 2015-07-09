require 'spec_helper'

RSpec.describe Sock::Drawer do
  describe "#new" do
    it "has defaults for all args" do
      Sock::Drawer.new
    end
  end

  it "subscribes to events from redis with that name" do

  end
end
