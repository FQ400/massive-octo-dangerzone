define [
  'chaplin',
  'models/configuration'
  'views/configuration_view',
], (Chaplin, Configuration, ConfigurationView) ->
  'use strict'

  class ConfigurationController extends Chaplin.Controller
    
    initialize: ->
      @subscribeEvent 'internal:game-configuration', @show
      super
      
    show: (params) ->
      @model = new Configuration()
      @view = new ConfigurationView(model: @model)
