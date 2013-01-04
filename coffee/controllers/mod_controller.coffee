define [
  'chaplin',
  'views/mod_view',
  'models/mod',
  'controllers/game_controller'
  'controllers/chat_controller'
  'controllers/menu_controller'
  'controllers/configuration_controller'
  'controllers/input_controller'
], (Chaplin, MODView, MoD, GameController, ChatController, MenuController, ConfigurationController, InputController) ->
  'use strict'

  class MODController extends Chaplin.Controller

    show: (params) ->
      console.log "MODController#show"
      @model = new MoD()
      @view = new MODView(model: @model)
      @subscribeEvent 'internal:start', @initializeGameAndChat
      
    initializeGameAndChat: (data) ->
      @game = new GameController
      @game.show
        name: data.name
        icon: data.icon

      @chat = new ChatController
      @chat.show()
      
      @menu = new MenuController
      @menu.show()
      
      @configuration = new ConfigurationController
      
      @input = new InputController

