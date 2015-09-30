require 'spec_helper'
require 'logger'
require 'mock_class'

RSpec.describe Sock::Subscriber do
  context 'when included' do
    it 'defines recieve' do
      expect(MockClass).to respond_to(:_recieve)
    end

    it 'runs the block when that event fires' do
      expect(MockClass._recieve('hi', 'ignored message')).to eq('success')
    end

    it 'can access the msg' do
      expect(MockClass._recieve('echo', 'hello')).to eq('hello')
    end
  end
end
