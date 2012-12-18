class Game
  
  options:
    timeout: 100
    ws_host: 'ws://localhost:9020'
  
  constructor: (opts, mediator) ->
    # overwrite default options
    $.extend(@options, opts)
    
    @pubsub = new Mediator()
    
    @ws = new WebSocket(@options.ws_host)
    @ws.onopen = =>
      console.log new WSPayload({subtype: 'open'}).type()
      @ws.send(new WSPayload({subtype: 'open'}).stringify())
      @ws.send("Hi Server2")
      
    @ws.onmessage = (msg) ->
      # @pubsub.Subscribe(msg)
      data = JSON.parse(msg)
      console.log data.type
      
    @ws.onerror = => @error()
    @ws.onclose = => @close()
    
  error: ->
    console.log new WSPayload({subtype: 'error'}).type()
    
  close: ->
    console.log new WSPayload({subtype: 'close'}).type()
