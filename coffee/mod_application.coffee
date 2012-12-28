define [
  'chaplin'
  'routes'
], (Chaplin, routes) ->
  'use strict'

  class MODApplication extends Chaplin.Application

    title: 'Massive Octo Dangerzone'

    initialize: ->
      super
      @initRouter routes
      Object.freeze? this
