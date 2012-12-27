require 'eventmachine'
require 'matrix'

class Game

  def initialize(app)
    @channel = EventMachine::Channel.new
    @users = []
    @app = app
    @start_positions = [[540, 100], [100, 380], [540, 380], [100, 100]]
    @last_update = Time.now.to_f
    @speed = 100
  end

  def join(user)
    return if @users.include?(user)
    init_user(user)
    @users.push(user)
    @app.chat_all("User '#{user.name}' joined the game")
    data = {:user => user.name}
    msg = {:type => :game, :subtype => :join, :data => data}.to_json
    @app.message_all(msg)
  end
  
  def leave(user)
    return unless @users.include?(user)
    @start_positions.push(user.start_position.to_a)
    user.unsubscribe(@channel, :game)
    @users.delete(user)
    @app.chat_all("User '#{user.name}' left the game")
  end

  def init_user(user)
    users = {}
    @users.each { |_user| users[_user.name] = {:name => _user.name}}
    data = {:users => users}
    msg = {:type => :game, :subtype => :init, :data => data}.to_json
    @app.message(user, msg)
    user.subscribe(@channel, :game)
    user.init_position(@start_positions.pop)
  end

  def move_users
    now = Time.now.to_f
    time_since_last = now - @last_update
    move_scale = time_since_last * @speed
    @last_update = now
    @users.each do |user|
      diff1 = [-1, -1].zip(user.key_states[0..1]).collect { |e1, e2| e1 * e2 }
      diff2 = [1, 1].zip(user.key_states[2..3]).collect { |e1, e2| e1 * e2 }
      diff = Vector.elements(diff1) + Vector.elements(diff2)
      diff *= move_scale
      move_user(user, diff)
    end
  end

  def move_user(user, diff)
    user.position += Vector.elements(diff)
  end

  def user_pos
    user_pos = {}
    @users.each { |user| user_pos[user.name] = user.position.to_a}
    user_pos
  end
end
