define [
  'chaplin',
], (Chaplin) ->
  'use strict'

  class User extends Chaplin.Model

    constructor: (name, icon, position) ->
      @icon_ready = false
      @name = name
      @position = position
      @set_icon(icon)
      @radiant = 0
      
    set_position: (pos) ->
      @position = pos
    
    get_position: ->
      return @position

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
