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
      keys = [key for key in _.keys(opts) when opts[key]]
      $.extend(@options, _.pick(opts, keys...))
      @ws = new WebSocket(@options.ws_host)
      @ws.onopen = => @socket_opened()
      @ws.onerror = => @error()
      @ws.onclose = => @close()
      @ws.onmessage = (msg) => @server_message(msg)
      console.log @options

    socket_opened: ->
      Chaplin.mediator.subscribe 'server:send', (data) =>
        @send_to_server(data)

      payload = new WSPayload
        data:
          name: @options.name
          icon: @options.icon
      Chaplin.mediator.send_to_server(payload)

    error: ->
      console.log "There was an Error."

    close: ->
      console.log "Socket closed."

    server_message: (msg) ->
      try
        data = JSON.parse(msg.data)
        Chaplin.mediator.publish([data['type'], data['subtype']].join(':'), data)
      catch error
        console.log error
        return false

    send_to_server: (payload) ->
      @ws.send(payload.stringify())
