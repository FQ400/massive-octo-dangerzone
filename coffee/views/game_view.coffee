define [
  'views/base/view'
  'text!templates/game.hbs'
  'models/canvas'
], (View, template, Canvas) ->
  'use strict'

  class GameView extends View

    template: template
    className: 'game'
    container: '#canvas-container'
    autoRender: true

    initialize: ->
      @idle = true
      setInterval(
        => @idle = true,
        50)
      super
      @delegate 'keydown', '#game_canvas', (event) =>
        @publishEvent 'internal:canvas_keydown', event.keyCode
      @delegate 'keyup', '#game_canvas', (event) =>
        @publishEvent 'internal:canvas_keyup', event.keyCode
      @delegate 'mousemove', '#game_canvas', (event) =>
        if @idle
          @publishEvent 'internal:canvas_mouse_move', @page_coords_to_game([event.pageX, event.pageY])
          @idle = false
      @delegate 'click', (event) =>
        @publishEvent 'internal:shoot', event

    afterRender: ->
      super
      @canvas = new Canvas(document.getElementById('game_canvas'))

    page_coords_to_game: (pos) ->
      total_offset = $('#'+@canvas.id).position()
      [pos[0] - total_offset.left, pos[1] - total_offset.top]
