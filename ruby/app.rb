require_relative 'user'

class App
  def initialize *args
    @users = {}
    @channels = puts *args[0]
  end

  def register(data, socket)
    @users[socket] = User.new(data['name'], socket)
    puts "created user '#{data['name']}'"

  end
end
