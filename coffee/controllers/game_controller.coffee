define [
  'chaplin',
  'views/game_view',
  'models/game',
  'controllers/chat_controller',
  'controllers/canvas_controller',
  'models/game_payload',
  'models/user',
], (Chaplin, GameView, Game, ChatController, CanvasController, GamePayload, User) ->
  'use strict'

  class GameController extends Chaplin.Controller

    constructor: ->
      super
      @users = []
      @initialized = false

    subscribeToChannels: ->
      mediator = Chaplin.mediator
      # mediator.subscribe 'object:created', (data) =>
      #   id = data.id
      #   data = data.data
      #   @object_created(id, data)

      mediator.subscribe 'user:deleted', (data) =>
        name = data.data
        @user_deleted(name)

      # mediator.subscribe 'object:deleted', (data) =>
      #   id = data.id
      #   @object_deleted(id)

      mediator.subscribe 'game:join', (data) =>
        @user_join(data.data.user)

      mediator.subscribe 'game:leave', (data) =>
        @user_leave(data.data.user)

      mediator.subscribe 'game:init', (data) =>
        @init_state()

      mediator.subscribe 'game:state', (data) =>
        @update_state(data)

      mediator.subscribe 'game:user_list', (data) =>
        @user_list(data)

    show: (params) ->
      @model = new Game(params)
      @view = new GameView(model: @model)
      @canvas = new CanvasController(document.getElementById('game_canvas'))

    join: ->
      payload = new GamePayload
        subtype: 'join'
      
      Chaplin.mediator.sendToServer(payload)
      $('#canvas-container').focus()

    leave: ->
      payload = new GamePayload
        subtype: 'leave'
      Chaplin.mediator.sendToServer(payload)
      @initialized = false

    user_join: (user) ->
      console.log("join: " + user)

    user_leave: (user) ->
      console.log("leave: " + user)

    user_list: (data) ->
      for user in data.data.users
        @users[user.name] = new User(user.name, user.icon, user.position)

    user_deleted: (name) ->
      if @users[name]
        console.log('deleted: ' + name)
        delete @users[name]

    object_created: (id, data) ->
      @objects[id] = new GameObject(id, data)

    object_deleted: (id) ->
      if @objects[id]
        console.log('deleted: ' + id)
        delete @objects[id]

    init_state: ->
      @initialized = true

    update_state: (data) ->
      if @initialized
        @update_positions(data.data.positions)
        @redraw()

    update_positions: (positions) ->
      for user, position of positions.user
        @users[user].set_position(position)

    redraw: ->
      @canvas.clear()
      for name, user of @users
        @canvas.draw_user(user)

    keydown: (code) ->
      payload = new GamePayload
        subtype: 'keydown'
        data: code
      Chaplin.mediator.sendToServer(payload)

    keyup: (code) ->
      payload = new GamePayload
        subtype: 'keyup'
        data: code
      Chaplin.mediator.sendToServer(payload)
