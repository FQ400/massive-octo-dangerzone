define [
  'chaplin',
], (Chaplin) ->
  'use strict'

  class Menu extends Chaplin.Model

    defaults:
      title: 'Massive Octo Dangerzone'
      items: [
        { id: 'join-game', href: '#join', title: 'Join'}
        { id: 'leave-game', href: '#leave', title: 'Leave' }
        { id: 'configure-game', href: 'configure', title: 'Configure' }
      ]

