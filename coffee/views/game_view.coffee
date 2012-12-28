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
