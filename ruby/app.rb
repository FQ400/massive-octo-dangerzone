require_relative 'user'

class App
  def initialize *args
    @users = []
  end

  def register data
    puts data
    user = User.new(data['name'])
    @users.push(user)
  end
end
