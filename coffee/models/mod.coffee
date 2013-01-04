define [
  'chaplin',
], (Chaplin) ->
  'use strict'

  class MoD extends Chaplin.Model

    defaults:
      title: 'Massive Octo Dangerzone'
      username: 'default'
      icon: 'http://www.gamesaktuell.de/screenshots/970x546/2012/04/Trollfaces-Kompendium_-_Me_Gusta_Guy.JPG'
      host: 'ws://localhost:9020'
