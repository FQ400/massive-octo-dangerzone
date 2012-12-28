define [
  'models/ws_payload',
], (WSPayload) ->
  'use strict'

  class ChatPayload extends WSPayload
    
    options:
      type : 'chat'
