require 'eventmachine'

class Game
  def initialize(app)
    @channel = EventMachine::Channel.new
    @users = []
    @app = app
  end

  def join(user)
    return if @users.include?(user)
    user.subscribe(@channel, :game)
    @users.push(user)
    @app.chat_all("User '#{user.name}' joined the game")
  end
  
  def leave(user)
    return unless @users.include?(user)
    user.unsubscribe(@channel, :game)
    @users.delete(user)
    @app.chat_all("User '#{user.name}' left the game")
  end
end
