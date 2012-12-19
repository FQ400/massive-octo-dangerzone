class Game
  
  options:
    timeout   : 100
    ws_host   : 'ws://localhost:9020'
    name      : 'fnord'
  
  constructor: (opts) ->
    # overwrite default options
    $.extend(@options, opts)
    
    @pubsub = new Mediator()
    @subscribeToChannels(@pubsub)
    
    @users = []
    
    @ws = new WebSocket(@options.ws_host)
    @ws.onopen = => @openCallback()
    @ws.onerror = => @error()
    @ws.onclose = => @close()
    @ws.onmessage = (msg) => @messageCallback(msg)
  
  subscribeToChannels: (mediator, data) ->
    mediator.Subscribe 'chat:new_message', (data) =>
      Chat.addMessage(data)
    
    mediator.Subscribe 'user:created', (data) =>
      User.create(data)
  
  openCallback: ->
    payload = new WSPayload
      data:
        name: @options.name
        
    @ws.send(payload.stringify())
    
  
  error: ->
    console.log "There was an Error."
    
  close: ->
    console.log "Socket closed."
    
  messageCallback: (msg) ->
    
    try
      data = JSON.parse(msg.data)
    catch error
      console.log error
      return false
      
    @pubsub.Publish([data['type'], data['subtype']].join(':'), data)
