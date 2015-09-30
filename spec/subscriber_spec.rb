require 'spec_helper'
require 'logger'
require 'mock_class'

RSpec.describe Sock::Subscriber do
  context 'when included' do
    it 'runs the block when that event fires' do
      expect(MockClass.channels['hi'].call('hello')).to eq('success')
    end

    it 'can access the msg' do
      expect(MockClass.channels['echo'].call('hello')).to eq('hello')
    end
  end
end
