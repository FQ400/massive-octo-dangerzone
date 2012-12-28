define [
  'chaplin',
  'views/game_view',
  'models/game',
  'controllers/chat_controller',
  'controllers/canvas_controller',
  'models/ws_payload',
  'models/game_payload',
  'models/chat_payload',
  'models/user',
], (Chaplin, GameView, Game, ChatController, CanvasController, WSPayload, GamePayload, ChatPayload, User) ->
  'use strict'

  class GameController extends Chaplin.Controller

    options:
      timeout   : 100
      ws_host   : 'ws://localhost:9020'
      name      : 'fnord'
      icon      : null

    constructor: (opts) ->
      super
      $.extend(@options, opts)

      @pubsub = Chaplin.mediator
      @subscribeToChannels(@pubsub)

      @users = []
      @chat = new ChatController(this)
      @initialized = false

      @ws = new WebSocket(@options.ws_host)
      @ws.onopen = => @openCallback()
      @ws.onerror = => @error()
      @ws.onclose = => @close()
      @ws.onmessage = (msg) => @messageCallback(msg)

    subscribeToChannels: (mediator, data) ->
      mediator.subscribe 'chat:new_message', (data) =>
        @chat.new_message(data)

      mediator.subscribe 'object:created', (data) =>
        id = data.id
        data = data.data
        @object_created(id, data)

      mediator.subscribe 'user:deleted', (data) =>
        name = data.data
        @user_deleted(name)

      mediator.subscribe 'object:deleted', (data) =>
        id = data.id
        @object_deleted(id)

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
      @model = new Game()
      @view = new GameView(model: @model)
      @canvas = new CanvasController(document.getElementById('game_canvas'))
      @chat.show()

    openCallback: ->
      payload = new WSPayload
        data:
          name: @options.name
          icon: @options.icon

      @ws.send(payload.stringify())

    error: ->
      console.log "There was an Error."

    close: ->
      console.log "Socket closed."

    messageCallback: (msg) ->
      try
        data = JSON.parse(msg.data)
      catch error
        console.log error
        return false

      @pubsub.publish([data['type'], data['subtype']].join(':'), data)

    send_chat: (msg) ->
      payload = new ChatPayload
        data:
          message: msg
        subtype: 'public_message'
      @ws.send(payload.stringify())

    join: ->
      payload = new GamePayload
        subtype: 'join'
      @ws.send(payload.stringify())
      $('#canvas-container').focus()

    leave: ->
      payload = new GamePayload
        subtype: 'leave'
      @ws.send(payload.stringify())
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
      @ws.send(payload.stringify())

    keyup: (code) ->
      payload = new GamePayload
        subtype: 'keyup'
        data: code
      @ws.send(payload.stringify())
