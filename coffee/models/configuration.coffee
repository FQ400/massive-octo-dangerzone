define [
  'chaplin',
], (Chaplin) ->
  'use strict'

  class Configuration extends Chaplin.Model

    defaults:
      name: '123'