define [
  'models/ws_payload',
], (WSPayload) ->
  'use strict'

  class GamePayload extends WSPayload
    options:
      type: 'game'
