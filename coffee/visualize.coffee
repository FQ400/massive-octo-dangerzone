class VizApp
  
  options: 
    ws_host: 'ws://localhost:9020'
    
  clients: {}
  
  constructor: ->
    
    $('#canvas-container').css
      width: $(document).width() + 'px'
      height: $(document).height() + 'px'
    
    # all movements and clicks are on the same stage
    ClientViz.stage = new Kinetic.Stage
      container : 'canvas-container'
      width     : $(document).width()
      height    : $(document).height()
    
    @socket = new WebSocket( @options.ws_host + '?viz=1' )
    @socket.onmessage = (msg) =>
      client = @clients[VizSupport.client_id(msg.data)]
      
      if client
        client.draw_points(msg.data)
      else
        @clients[VizSupport.client_id(msg.data)] = new ClientViz(msg.data)
    
window.onload += new VizApp()

