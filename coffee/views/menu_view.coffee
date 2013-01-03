define [
  'chaplin',
  'views/base/view',
  'text!templates/menu.hbs'
], (Chaplin, View, template) ->
  'use strict'

  class MenuView extends View

    template:         template
    className:        'menu'
    container:        '#menu'
    containerMethod:  'html'
    autoRender:       true

    initialize: ->
      @delegate 'click', '#join-game', (event) =>
        event.preventDefault()
        @publishEvent 'internal:game-join'
        $('#join-game').hide()
        $('#leave-game').show()
      
      @delegate 'click', '#leave-game', (event) =>
        event.preventDefault()
        @publishEvent 'internal:game-leave'
        $('#join-game').show()
        $('#leave-game').hide()
        
    afterRender: ->
      super
      $('#leave-game').hide()
      
      # $('#configure').on 'click', (event) =>
      #   event.preventDefault()
      #   @enable_configure_controls()
      
      # enable_configure_controls: ->
      #   $('#config-container').html('')
