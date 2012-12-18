class TrackerApp
  
  options: 
    timeout: 100
    ws_host: 'ws://localhost:9020'
    
  constructor: (opts) ->
    # overwrite default options
    $.extend(@options, opts)
    
    @socket = new WebSocket(@options.ws_host)
    @socket.onopen = => @bind_tracking_events()
    @socket.onmessage = (msg) => @output(msg)

    @socket_id = 'socket_' + new Date().getTime()
    
    # used for send data to server every 100ms
    @idle = true
    setInterval(
      => @idle = true,
      @options.timeout
    )
    
  bind_tracking_events: ->
    $(document).on 'mousemove click', (event) => 
      if event.type is 'click'
        @send_msg(event)
      
      if @idle == true and event.type == 'mousemove'
        @send_msg(event)
        @idle = false
      
  
  send_msg: (event) ->
    # [x, y, timestamp, event_type, socket_id]
    @socket.send([
      event.pageX, 
      event.pageY, 
      new Date().getTime(), 
      event.type,
      @socket_id
    ])
  
  chat_msg: (msg) ->
    @socket.send(msg)
  
  output: (msg) ->
    $('#chat').append('<span>' + msg.data + '</span><br/>')
    console.log msg

window.onload += new TrackerApp()

