define [
  'chaplin',
], (Chaplin) ->
  'use strict'

  class Game extends Chaplin.Model

    defaults:
      width: 640
      height: 480
