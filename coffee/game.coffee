class Game
  
  options:
    timeout   : 100
    ws_host   : 'ws://localhost:9020'
    nickname  : 'fnord'
  
  constructor: (opts) ->
    # overwrite default options
    $.extend(@options, opts)
    
    console.log(@options)
    
    # @pubsub = new Mediator()
    
    @ws = new WebSocket(@options.ws_host)
    @ws.onopen = =>
      payload = new WSPayload()
        data: 1
          nickname: @options.nickname
      
      @ws.send(new WSPayload(payload.stringify())
      
    # @ws.onmessage = (msg) =>
    #   # @pubsub.Subscribe(msg)
    #   # data = JSON.parse(msg)
    #   console.log msg
      
    @ws.onerror = => @error()
    @ws.onclose = => @close()
  
  error: ->
    console.log new WSPayload({subtype: 'error'}).type()
    
  close: ->
    console.log new WSPayload({subtype: 'close'}).type()
