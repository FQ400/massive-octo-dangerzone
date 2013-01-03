define [
  'views/base/view'
  'text!templates/game.hbs'
], (View, template) ->
  'use strict'

  class GameView extends View

    template: template
    className: 'game'
    container: '#canvas-container'
    autoRender: true

    initialize: ->
      super
      @delegate 'keydown', '#game_canvas', (event) =>
        @publishEvent 'internal:canvas_keydown', event.keyCode
      @delegate 'keyup', '#game_canvas', (event) =>
        @publishEvent 'internal:canvas_keyup', event.keyCode
