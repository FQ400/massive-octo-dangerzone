define [
  'chaplin',
  'views/mod_view',
  'models/mod',
  'controllers/game_controller'
], (Chaplin, MODView, MoD, GameController) ->
  'use strict'

  class MODController extends Chaplin.Controller

    show: (params) ->
      @model = new MoD()
      @view = new MODView(model: @model)
      @bind_page_events()
      $('#username').val('default')
      
    bind_page_events: ->
      $('#start-game').on 'click', (event) =>
        name = $('#username').val()
        icon = $('#icon').val()
        if name
          event.preventDefault()
          @game = new GameController
            name: name
            icon: icon
          @game.show()
          @enable_join_controls()

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
