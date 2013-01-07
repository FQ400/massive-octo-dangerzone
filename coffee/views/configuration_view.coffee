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
    
    assignment_in_progress: false
      
    afterRender: ->
      @delegate 'click', 'a.close', (event) => 
        event.preventDefault()
        @publishEvent 'internal:rebind_keys'
        @.dispose()
      
      @delegate_key_binding_styles()
      super
      
    delegate_key_binding_styles: ->
      @delegate 'mouseover', '.key', (event) =>
        unless @assignment_in_progress
          $(event.target).addClass('shadow')
        else
          return false
      
      @delegate 'mouseout', '.key', (event) =>
        unless @assignment_in_progress
          $(event.target).removeClass('shadow')
        else
          return false
      
      @delegate 'focus', '.key', (event) =>
        @assignment_in_progress = true
        $(event.target).val('')
      
      @delegate 'keyup', '.key', (event) =>
        if @assignment_in_progress
          console.log event.keyCode
          id = $(event.target).attr('id')
          @publishEvent 'internal:map_key',
            'key': id
            'code': event.keyCode
          $(event.target).removeClass('shadow').blur()
          @assignment_in_progress = false
        else
          return false
        
      
        