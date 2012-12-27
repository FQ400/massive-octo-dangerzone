class GameApp
  
  constructor: ->
    @bind_page_events()
    $('#username').val('default')
    
  bind_page_events: ->
    $('#start-game').on 'click', (event) =>
      name = $('#username').val()
      if name
        event.preventDefault()
        @game = new Game
          name: name
        @enable_join_controls()
      
    $('#chat-submit').on 'click', (event) =>
      event.preventDefault()
      message = $('#chat-msg').val()
      if @game and message
        @game.send_chat(message)
        $('#chat-msg').val('')

    $('#canvas-container').on 'keydown', (event) =>
      event.preventDefault()
      @game.keydown(event.keyCode)

    $('#canvas-container').on 'keyup', (event) =>
      event.preventDefault()
      @game.keyup(event.keyCode)

  enable_join_controls: ->
    $('#menu').html('<a id="join-game" href="#join" title="join">Join</a>')
    $('#join-game').on 'click', (event) =>
      event.preventDefault()
      @game.join()
      @enable_leave_controls()

  enable_leave_controls: ->
    $('#menu').html('<a id="leave-game" href="#leave" title="leave">Leave</a>')
    $('#leave-game').on 'click', (event) =>
      event.preventDefault()
      @game.leave()
      @enable_join_controls()
