require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'eventmachine'
require 'em-websocket'
require 'em-hiredis'
require 'json'

require_relative 'app'

def bla
  puts 'bla'
end

EventMachine.run do

  puts 'Game server started... ;)'

  @app = App.new

  EventMachine::WebSocket.start(:host => 'localhost', :port => 9020) do |socket|
  # EventMachine::WebSocket.start(:host => '10.20.1.9', :port => 9020) do |socket|

    socket.onopen do
      puts "WebSocket opened!"
    end

    socket.onmessage do |msg|
      begin
        data = JSON.parse(msg)
      rescue JSON::ParserError => e
        puts e
      else
        puts data
        if data['subtype'] == 'init'
          @app.register(data['data'], socket)
        end
      end
    end

    socket.onclose do
      @app.remove_user(socket)
      puts "WebSocket closed!"
    end
  end
end
