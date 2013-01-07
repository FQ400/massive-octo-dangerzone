define [
  'chaplin',
  'views/game_view',
  'models/game',
  'controllers/chat_controller',
  'models/game_payload',
  'models/user',
  'models/game_object',
], (Chaplin, GameView, Game, ChatController, GamePayload, User, GameObject) ->
  'use strict'

  class GameController extends Chaplin.Controller

    constructor: ->
      super
      @users = {}
      @objects = {}
      @initialized = false
      @subscribe_to_channels()

    subscribe_to_channels: ->
      mediator = Chaplin.mediator
      @subscribeEvent 'internal:game-join', @join
      @subscribeEvent 'internal:game-leave', @leave

      mediator.subscribe 'user:deleted', (data) =>
        name = data.data
        @user_deleted(name)

      mediator.subscribe 'game:join', (data) =>
        @user_join(data.user)

      mediator.subscribe 'game:leave', (data) =>
        @user_leave(data.user)

      mediator.subscribe 'game:init', (data) =>
        @init_state(data.id)

      mediator.subscribe 'game:state', (data) =>
        @update_state(data)

      mediator.subscribe 'game:user_list', (data) =>
        @user_list(data)

      mediator.subscribe 'game:object_list', (data) =>
        @object_list(data)

      mediator.subscribe 'game:objects_created', (data) =>
        @objects_created(data)

      mediator.subscribe 'game:objects_deleted', (data) =>
        @objects_deleted(data)

      mediator.subscribe 'internal:shoot', (data) =>
        @shoot(data)

    show: (params) ->
      Chaplin.mediator.game = @model = new Game(params)
      @view = new GameView(model: @model)
    
    join: ->
      payload = new GamePayload
        subtype: 'join'
      Chaplin.mediator.send_to_server(payload)
      $('#game_canvas').focus()

    leave: ->
      payload = new GamePayload
        subtype: 'leave'
      Chaplin.mediator.send_to_server(payload)
      @initialized = false

    user_join: (user) ->
      Chaplin.mediator.user = @users[@user_id]
      console.log("join: " + user)

    user_leave: (user) ->
      console.log("leave: " + user)

    user_list: (data) ->
      @users = {}
      for user in data.users
        @users[user.name] = new User(user.id, user.icon, user.position, user.name)
      Chaplin.mediator.publish 'internal:update_users', @users

    objects_created: (data) ->
      objects = []
      for obj in data.objects
        @objects[obj.id] = new GameObject(obj.id, obj.icon, obj.position, obj.size)
        objects.push(@objects[obj.id])
      Chaplin.mediator.publish 'internal:objects_created', objects

    objects_deleted: (data) ->
      objects = []
      for obj in data.objects
        delete @objects[obj.id]
      Chaplin.mediator.publish 'internal:objects_deleted', data.objects

    user_deleted: (name) ->
      if @users[name]
        console.log('deleted: ' + name)
        delete @users[name]

    init_state: (id) ->
      @user_id = id
      Chaplin.mediator.user = @objects[@user_id]
      @initialized = true

    update_state: (data) ->
      if @initialized
        @update_positions(data.positions, data.angles)

    update_positions: (positions, angles) ->
      for obj in angles
        @objects[obj.id].angle = obj.angle
      for obj in positions
        @objects[obj.id].position = obj.position
      Chaplin.mediator.publish 'internal:update_positions', @objects

    shoot: (event) ->
      position = @view.page_coords_to_game([event.pageX, event.pageY])
      payload = new GamePayload
        subtype: 'shoot'
        data: position
      Chaplin.mediator.send_to_server(payload)
