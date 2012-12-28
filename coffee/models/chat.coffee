define [
  'chaplin',
], (Chaplin) ->
  'use strict'

  class Chat extends Chaplin.Model

    defaults:
      width: 640
      height: 480
