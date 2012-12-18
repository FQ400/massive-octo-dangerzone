class GameApp
  
  constructor: ->
    @bind_page_events()
    
    
  bind_page_events: ->
    $('#start-game').on 'click', (event) =>
      event.preventDefault()
      
      game = new Game
        name: $('#username').val()
      
      