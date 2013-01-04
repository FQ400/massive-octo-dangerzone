define [
  'chaplin',
], (Chaplin) ->
  'use strict'

  class GameObject extends Chaplin.Model

    constructor: (id, icon, position) ->
      super
      @id = id
      @position = position
      @set_icon(icon)
      @icon_ready = false
      @angle = 0

    set_icon: (icon) ->
      if icon
        @icon_ready = false
        @icon = new Image()
        @icon.src = icon
        @icon.onload = =>
          @icon_ready = true
          Chaplin.mediator.publish 'internal:user_icon_ready', @
      else
        icon = null

