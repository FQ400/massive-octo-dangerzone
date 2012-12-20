require 'eventmachine'
require 'em-websocket'

require_relative 'user'
require_relative 'game'

class App
  def initialize
    @users = {}
    @chat = EventMachine::Channel.new
    @game = Game.new(self)
  end

  def register(data, socket)
    name = data['name']
    remove_user(name)
    chat_id = @chat.subscribe do |msg|
      socket.send(msg)
    end
    @users[socket] = User.new(name, socket, chat_id)
    chat_all("User '#{name}' signed on")
  end

  def remove_user(crit)
    user = find_user(crit)
    unless user.nil?
      @chat.unsubscribe(user.chat_id)
      chat_all("User '#{user.name}' signed off")
      @users.delete user.socket
    end
  end

  def chat_all(_message, user=nil)
    user = find_user(user)
    _message = "|#{user.name}| #{_message}" unless user.nil?
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
    if crit.kind_of?(EventMachine::WebSocket::Connection)
      @users.fetch(crit, nil)
    elsif crit.kind_of?(String)
      matches = @users.values.select { |u| u.name == crit }
      matches[0] if matches
    end
  end

  def chat_message(data, socket)
    case data['subtype']
    when 'public_message' then chat_all(data['data']['message'], socket)
    end
  end

  def game_message(data, socket)
    case data['subtype']
    when 'join' then user_join(find_user(socket))
    when 'leave' then user_leave(find_user(socket))
    end
  end

  def user_join(user)
    return if user.nil?
    @game.join(user)
  end

  def user_leave(user)
    return if user.nil?
    @game.leave(user)
  end
end
