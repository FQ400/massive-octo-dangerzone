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
        @init_state()

      mediator.subscribe 'game:state', (data) =>
        @update_state(data)

      mediator.subscribe 'game:user_list', (data) =>
        @user_list(data)

      mediator.subscribe 'game:object_list', (data) =>
        @object_list(data)

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
      console.log("join: " + user)

    user_leave: (user) ->
      console.log("leave: " + user)

    user_list: (data) ->
      for user in data.users
        @users[user.name] = new User(user.id, user.icon, user.position, user.name)
      Chaplin.mediator.user = @users[@model.options.name]
      Chaplin.mediator.publish 'internal:update_users', @users

    object_list: (data) ->
      for obj in data.objects
        @objects[obj.id] = new GameObject(obj.id, obj.icon, obj.position)
      Chaplin.mediator.publish 'internal:update_objects', @objects

    user_deleted: (name) ->
      if @users[name]
        console.log('deleted: ' + name)
        delete @users[name]

    init_state: ->
      @initialized = true

    update_state: (data) ->
      if @initialized
        @update_positions(data.positions, data.radiants)

    update_positions: (positions, radiants) ->
      for user, position of positions.user
        @users[user].set_position(position)
      for user, radiant of radiants.user
        @users[user].radiant = radiant 
      for obj, position of positions.object
        @objects[obj].position = position
      Chaplin.mediator.publish 'internal:update_positions', @users, @objects

    shoot: (event) ->
      position = @view.page_coords_to_game([event.pageX, event.pageY])
      payload = new GamePayload
        subtype: 'shoot'
        data: position
      Chaplin.mediator.send_to_server(payload)
