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

  @sockets = []
  @channel_subscribers = {}
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
      @channel_subscribers[socket] = cid
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
      socket.send({:type => :chat, :subtype => :new_message, :data => "neuer Nutzer #{data['data']['name']}" }.to_json)
    end

    socket.onclose do
      cid = @channel_subscribers[socket]
      @sockets.delete socket
      @chat.unsubscribe(cid)
      puts "WebSocket closed!"
    end
  end
end
