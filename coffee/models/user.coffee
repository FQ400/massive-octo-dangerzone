define [
  'chaplin',
], (Chaplin) ->
  'use strict'

  class User extends Chaplin.Model

    constructor: (name, icon, position) ->
      @icon_ready = false
      @name = name
      if icon
        @icon = new Image()
        @icon.src = icon
        @icon.onload = =>
          @icon_ready = true
          Chaplin.mediator.publish 'internal:user_icon_ready', this
      else
        icon = null
      @position = position

    set_position: (pos) ->
      @position = pos
