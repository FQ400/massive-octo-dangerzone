require 'eventmachine'
require 'em-websocket'

require_relative 'user'

class App
  def initialize
    @users = {}
    @chat = EventMachine::Channel.new
  end

  def register(data, socket)
    puts socket.inspect
    name = data['name']
    remove_user(name)
    chat_id = @chat.subscribe do |msg|
      socket.send(msg)
    end
    @users[socket] = User.new(name, socket, chat_id)
    puts "created user '#{name}'"
    chat_all("User '#{name}' signed on")
  end

  def remove_user(crit)
    user = find_user(crit)
    unless user.nil?
      @chat.unsubscribe(user.chat_id)
      puts "removed user '#{user.name}'"
      chat_all("User '#{user.name}' signed off")
      @users.delete user.socket
    end
  end

  def chat_all(_message)
    msg = {:type => :chat, :subtype => :new_message, :data => _message}.to_json
    @chat.push(msg)
  end

  def message_all(_message)
    @users.each do |user|
      message(user, _message)
    end
  end

  def message(user, _message)
    user.socket.send(_message)
  end

  def find_user(crit)
    if crit.kind_of?(EventMachine::WebSocket)
      @users.fetch(socket, nil)
    elsif crit.kind_of?(String)
      matches = @users.values.select { |u| u.name == crit }
      matches[0] if matches
    end
  end
end
