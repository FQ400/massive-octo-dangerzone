require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'eventmachine'
require 'em-websocket'
require 'em-hiredis'
require 'json'

require_relative 'app'

EventMachine.run do

  puts 'Game server started... ;)'

  @sockets = []
  @channels = {}
  @chat = EventMachine::Channel.new
  @app = App.new

  EventMachine::WebSocket.start(:host => 'localhost', :port => 9020) do |socket|
  # EventMachine::WebSocket.start(:host => '10.20.1.9', :port => 9020) do |socket|

    socket.onopen do
      @sockets << socket
      puts "WebSocket opened!"

      cid = @chat.subscribe do |msg|
        puts "on subscribe #{msg}"
      end
      @channels[socket] = cid
    end

    socket.onmessage do |msg|
      begin
        data = JSON.parse(msg)
      rescue JSON::ParserError
      else
        puts data
        if data['subtype'] == 'register'
          @app.register(data['data'])
        end
      end
    end

    socket.onclose do
      cid = @channels[socket]
      @sockets.delete socket
      @chat.unsubscribe(cid)
      puts "WebSocket closed!"
    end
  end
end
