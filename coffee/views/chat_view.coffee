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
