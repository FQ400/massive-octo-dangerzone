define [
  'chaplin',
  'views/base/view',
  'text!templates/mod.hbs'
], (Chaplin, View, template) ->
  'use strict'

  class MODView extends View

    template: template
    className: 'mod'
    container: '#page-container'
    autoRender: true

    initialize: ->
      @delegate 'click', '#start-game', @setup
      
    setup: (event) ->
      event.preventDefault()
      name = $('#username').val()
      icon = $('#icon').val()
      if name
        @publishEvent 'internal:start',
          name: name
          icon: icon
