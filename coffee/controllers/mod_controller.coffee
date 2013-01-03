define [
  'chaplin',
  'views/mod_view',
  'models/mod',
  'controllers/game_controller'
  'controllers/chat_controller'
  'controllers/input_controller'
], (Chaplin, MODView, MoD, GameController, ChatController, InputController) ->
  'use strict'

  class MODController extends Chaplin.Controller

    show: (params) ->
      @model = new MoD()
      @view = new MODView(model: @model)
      @subscribeEvent 'internal:start', @initializeGameAndChat
      
    initializeGameAndChat: (data) ->
      @game = new GameController
      @game.show({
        name: data.name
        icon: data.icon
      })
      @chat = new ChatController
      @chat.show()
      
      @input = new InputController
      @enable_join_controls()

    enable_join_controls: ->
      $('#menu').html('<a id="join-game" href="#join" title="join">Join</a><a id="configure" href="configure" title="configure">Configure</a><div id="config-container"></div>')
      $('#join-game').on 'click', (event) =>
        event.preventDefault()
        @game.join()
        @enable_leave_controls()
      $('#configure').on 'click', (event) =>
        event.preventDefault()
        @enable_configure_controls()

    enable_leave_controls: ->
      $('#menu').html('<a id="leave-game" href="#leave" title="leave">Leave</a><a id="configure" href="configure" title="configure">Configure</a>')
      $('#leave-game').on 'click', (event) =>
        event.preventDefault()
        @game.leave()
        @enable_join_controls()
        $('#configure').on 'click', (event) =>
          event.preventDefault()
          @enable_configure_controls()

    enable_configure_controls: ->
      $('#config-container').html('')
