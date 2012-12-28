define [
  'chaplin',
], (Chaplin) ->
  'use strict'

  class WSPayload extends Chaplin.Model
    
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
