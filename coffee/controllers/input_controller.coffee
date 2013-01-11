define [
  'chaplin',
  'models/game_payload',
], (Chaplin, GamePayload) ->
  'use strict'

  class InputController extends Chaplin.Controller

    initialize: ->
      super
      @keys = {37: 'left', 38: 'up', 39: 'right', 40: 'down'}
      @subscribeEvent 'internal:canvas_keydown', (code) =>
        @key('down', code)
      @subscribeEvent 'internal:canvas_keyup', (code) =>
        @key('up', code)
      @subscribeEvent 'internal:canvas_mouse_move', (coords) =>
        @calc_angle(coords)
      

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
      @keys[old_code] = null
      @keys[code] = key
      
    
