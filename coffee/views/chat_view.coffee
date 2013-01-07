define [
  'views/base/view'
  'text!templates/chat.hbs'
], (View, template) ->
  'use strict'

  class ChatView extends View

    template: template
    className: 'chat'
    container: '#chat'
    autoRender: true
    
    afterRender: ->
      super
      @delegate 'click', '#chat-submit', (event) =>
        event.preventDefault()
        message = $('#chat-msg-input').val()
        if message
          @publishEvent 'internal:send_chat_message', message
          $('#chat-msg-input').val('')
          
      @delegate 'keyup', (event) =>
        message = $('#chat-msg-input').val()
        # send on return key
        if $('#chat-msg-input').is(':focus') and event.keyCode == 13 and message
          @publishEvent 'internal:send_chat_message', message
          $('#chat-msg-input').val('')
    