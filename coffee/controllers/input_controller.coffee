define [
  'chaplin',
  'models/game_payload',
  'views/configuration_view',
], (Chaplin, GamePayload, ConfigurationView) ->
  'use strict'

  class InputController extends Chaplin.Controller

    initialize: (params) ->
      super
      @keys = {65: 'left', 87: 'up', 68: 'right', 83: 'down'}
      @subscribeEvent 'internal:canvas_keydown', (code) =>
        @key('down', code)
      @subscribeEvent 'internal:canvas_keyup', (code) =>
        @key('up', code)
      @subscribeEvent 'internal:canvas_mouse_move', (coords) =>
        @calc_angle(coords)
        @send('mouse_move', coords)
      @subscribeEvent 'internal:game-configuration', @open_config
      @subscribeEvent 'internal:map_key', (data) =>
        @configure(data.key, data.code)
      
    key: (type, code) ->
      if @keys[code]
        @send('key' + type, @keys[code])

    calc_angle: (coords) ->
      return unless Chaplin.mediator.user
      p_pos = Chaplin.mediator.user.position
      # mouse position
      mx = coords[0]
      my = coords[1]
      # player position
      px = p_pos[0]
      py = p_pos[1]

      theta = Math.atan2(px - mx, py - my)
      if theta
        @send('rotate', theta)

    send: (type, key) ->
      payload = new GamePayload
        subtype: type
        data: key
      Chaplin.mediator.send_to_server(payload)
      
    configure: (key, code) ->
      old_code = _.invert(@keys)[key]
      delete @keys[old_code]
      @keys[code] = key
<<<<<<< HEAD
=======
      
    open_config: ->
      @config_view = new ConfigurationView()
      
    
>>>>>>> parent of cca3307... Revert "removed generated files to prevent to compile code after cloning"
