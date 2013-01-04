define [
  'models/game_object',
], (GameObject) ->
  'use strict'

  class User extends GameObject

    constructor: (id, icon, position, name) ->
      super(id, icon, position)
      @name = name
