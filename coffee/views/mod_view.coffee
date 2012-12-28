define [
  'views/base/view'
  'text!templates/mod.hbs'
], (View, template) ->
  'use strict'

  class MODView extends View

    template: template
    className: 'mod'
    container: '#page-container'
    autoRender: true
