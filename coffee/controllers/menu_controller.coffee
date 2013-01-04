define [
  'chaplin',
  'models/menu'
  'views/menu_view',
], (Chaplin, Menu, MenuView) ->
  'use strict'

  class MenuController extends Chaplin.Controller
      
    show: (params) ->
      @model = new Menu()
      @view = new MenuView(model: @model)
    