class User
  attr_accessor :name
  attr_accessor :socket
  attr_accessor :chat_id

  def initialize name, socket, chat_id
    @name = name
    @socket = socket
    @chat_id = chat_id
    @ids = {}
  end

  def subscribe(channel, name)
    @ids[name] = channel.subscribe { |msg| socket.send(msg) }
  end

  def unsubscribe(channel, name)
    return unless @ids.has_key?(name)
    channel.unsubscribe(@ids[name])
    @ids.delete(name)
  end
end
