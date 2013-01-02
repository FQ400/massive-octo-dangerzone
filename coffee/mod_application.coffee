define [
  'chaplin'
  'routes'
], (Chaplin, routes) ->
  'use strict'

  class MODApplication extends Chaplin.Application

    title: 'Massive Octo Dangerzone'

    initialize: ->
      super
      @initDispatcher()
      @initLayout()
      
      @initMediator()
      
      @initRouter routes
      Object.freeze? this
    
    initMediator: ->
      Chaplin.mediator.game = null
      Chaplin.mediator.sendToServer = (data) ->
        Chaplin.mediator.publish('server:send', data)
      
      Chaplin.mediator.seal()