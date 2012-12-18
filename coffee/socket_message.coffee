class WSPayload
  
  options:
    type : 'socket'
  
  constructor: (opts) ->
    $.extend(@options, opts)
    
  type: ->
    [@options.type, @options.subtype].join(':')
  
  stringify: ->
    JSON.stringify
      type    : @options.type
      subtype : @options.subtype
      data    : 'Hi Server'


class ChatPayload extends WSPayload
  
  options:
    type : 'chat'
  
  constructor: (opts) ->
    super