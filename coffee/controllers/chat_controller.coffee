define [
  'chaplin',
  'views/chat_view',
  'models/chat',
], (Chaplin, ChatView, Chat) ->
  'use strict'

  class ChatController extends Chaplin.Controller

    constructor: (game) ->
      @game = game

    show: (params) ->
      @model = new Chat()
      @view = new ChatView(model: @model)
      console.log('asdfjlahfdlkja')
      $('#chat-submit').on 'click', (event) =>
        event.preventDefault()
        @send_message()

    new_message: (data) ->
      msg = data['data']
      $('#chat-content').append("<p>#{ msg }</p>")
      # scroll to bottom
      $('#chat-content').scrollTop($('#chat-content').height(), 0)

    send_message: ->
      console.log('inside')
      message = $('#chat-msg-input').val()
      if @game and message
        @game.send_chat(message)
        $('#chat-msg-input').val('')
