define [
  'chaplin',
  'models/ws_payload',
], (Chaplin, WSPayload) ->
  'use strict'

  class Game extends Chaplin.Model
    
    options:
      timeout   : 100
      ws_host   : 'ws://localhost:9020'
      name      : 'fnord'
      icon      : null
    
    defaults:
      width: 640
      height: 480
      
    initialize: (opts) ->
      $.extend(@options, opts)
      
      @ws = new WebSocket(@options.ws_host)
      @ws.onopen = => @openCallback()
      @ws.onerror = => @error()
      @ws.onclose = => @close()
      @ws.onmessage = (msg) => @messageCallback(msg)
      
  
    openCallback: ->
      Chaplin.mediator.subscribe 'server:send', (data) =>
        @sendToServer(data)
      
      payload = new WSPayload
        data:
          name: @options.name
          icon: @options.icon
      Chaplin.mediator.sendToServer(payload)

    error: ->
      console.log "There was an Error."

    close: ->
      console.log "Socket closed."

    messageCallback: (msg) ->
      try
        data = JSON.parse(msg.data)
        Chaplin.mediator.publish([data['type'], data['subtype']].join(':'), data)
      catch error
        console.log error
        return false
      
    sendToServer: (payload) ->
      @ws.send(payload.stringify())
      
    