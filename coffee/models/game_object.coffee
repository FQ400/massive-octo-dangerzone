define [
  'chaplin',
], (Chaplin) ->
  'use strict'

  class GameObject extends Chaplin.Model
    @ICONS: {}

    constructor: (id, icon, position, size) ->
      super
      @id = id
      @position = position
      @icon_ready = false
      @set_icon(icon)
      @angle = 0
      @size = size

    set_icon: (icon) ->
      if GameObject.ICONS[icon]
        @icon = GameObject.ICONS[icon]
        @icon_ready = true
      else if icon
        @icon_ready = false
        @icon = new Image()
        @icon.src = icon
        @icon.onload = =>
          @icon_ready = true
          GameObject.ICONS[icon] = @icon
          Chaplin.mediator.publish 'internal:user_icon_ready', @
      else
        icon = null

