class WSPayload
  
  options:
    type    : 'general'
    subtype : 'init'
  
  constructor: (opts) ->
    $.extend(@options, opts)
    
  type: ->
    [@options.type, @options.subtype].join(':')
  
  stringify: ->
    JSON.stringify
      type    : @options.type
      subtype : @options.subtype
      data    : @options.data


class ChatPayload extends WSPayload
  
  options:
    type : 'chat'
  
  constructor: (opts) ->
    super

class GamePayload extends WSPayload
  options:
    type: 'game'
