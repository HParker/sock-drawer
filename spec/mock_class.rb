class Foo
  def self.bar(string); end

  def subscribe_do_bar
    Sock::Client.new(redis: EM::Hiredis.connect).sub('hi', 'Foo', 'bar')
  end
end
