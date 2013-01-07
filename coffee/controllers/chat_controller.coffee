define [
  'chaplin',
  'views/chat_view',
  'models/chat',
  'models/chat_payload',
], (Chaplin, ChatView, Chat, ChatPayload) ->
  'use strict'

  class ChatController extends Chaplin.Controller

    initialize: ->
      super
      @subscribeEvent 'internal:send_chat_message', @send_message
      Chaplin.mediator.subscribe 'chat:new_message', @new_message

    show: (params) ->
      @model = new Chat()
      @view = new ChatView(model: @model)
      # $('#chat-submit').on 'click', (event) =>
      #   event.preventDefault()
      #   @send_message()

    new_message: (data) ->
      msg = data.message
      $('#chat-content').append("<p>#{ msg }</p>")
      # scroll to bottom
      $('#chat-content').scrollTop($('#chat-content').height(), 0)

    send_message: (message) ->
      if message
        payload = new ChatPayload
          data:
            message: message
          subtype: 'public_message'
        Chaplin.mediator.send_to_server(payload)
        
