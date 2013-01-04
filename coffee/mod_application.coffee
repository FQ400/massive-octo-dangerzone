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
      @initRouter routes
      @init_mediator()
      Object.freeze? this

    init_mediator: ->
      Chaplin.mediator.game = null
      Chaplin.mediator.user = null
      Chaplin.mediator.send_to_server = (data) ->
        Chaplin.mediator.publish('server:send', data)
      Chaplin.mediator.seal()
