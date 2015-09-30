class MockClass
  include Sock::Subscriber

  on 'hi' do
    'success'
  end

  on 'echo' do |msg|
    msg
  end

  on 'test' do |msg|
    puts "we did it"
    test_method
  end

  def self.test_method; end
end
