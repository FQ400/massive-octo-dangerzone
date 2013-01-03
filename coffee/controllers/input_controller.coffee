define [
  'chaplin',
  'models/game_payload',
], (Chaplin, GamePayload) ->
  'use strict'

  class InputController extends Chaplin.Controller
     
    initialize: ->
      @keys = {37: 'left', 38: 'up', 39: 'right', 40: 'down'}

    down: (code) ->
      if @keys[code]
        @send('keydown', @keys[code])

    up: (code) ->
      if @keys[code]
        @send('keyup', @keys[code])

    send: (type, key) ->
      payload = new GamePayload
        subtype: type
        data: key
      Chaplin.mediator.sendToServer(payload)

    configure: (key, code) ->
      old_code = _.invert(@keys)[key]
      @keys[old_code] = null
      @keys[code] = key