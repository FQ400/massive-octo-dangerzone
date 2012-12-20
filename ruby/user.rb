class User
  attr_accessor :name
  attr_accessor :socket
  attr_accessor :chat_id

  def initialize name, socket, chat_id
    @name = name
    @socket = socket
    @chat_id = chat_id
  end
end
