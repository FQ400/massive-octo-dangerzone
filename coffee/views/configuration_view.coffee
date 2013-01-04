define [
  'chaplin',
  'views/base/view',
  'text!templates/configuration.hbs'
], (Chaplin, View, template) ->
  'use strict'

  class ConfigurationView extends View

    template:         template
    className:        'configuration'
    container:        '#config-container'
    autoRender:       true