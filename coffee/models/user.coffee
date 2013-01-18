define [
  'models/game_object',
], (GameObject) ->
  'use strict'

  class User extends GameObject

    constructor: (id, icon, position, name, hp) ->
      super(id, icon, position)
      @name = name
      @hp = hp
