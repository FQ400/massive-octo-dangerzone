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

    initialize: ->
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

      mediator.subscribe 'game:state', (data) => @update_state(data)
      mediator.subscribe 'game:object_list', (data) => @object_list(data)
      mediator.subscribe 'game:objects_created', (data) => @objects_created(data)
      mediator.subscribe 'game:objects_deleted', (data) => @objects_deleted(data)
      mediator.subscribe 'internal:shoot', (data) => @shoot(data)

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

    objects_created: (data) ->
      objects = []
      for obj in data.objects
        if obj.visible
          gameObj = new GameObject(obj.id, obj.icon, obj.position, obj.size)
          @objects[obj.id] = gameObj
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
        @update_objects(data)

    update_objects: (data) ->
      objects = []
      for obj in data.objects
        objects.push(@objects[obj.id])
        @objects[obj.id].angle = obj.angle
        @objects[obj.id].position = obj.position
        @objects[obj.id].size = obj.size
        if 'hp' in obj
          @objects[obj.id].hp = obj.hp
      diff = _.intersection(objects, _.values(@objects))
      Chaplin.mediator.publish 'internal:update_objects', objects
      Chaplin.mediator.publish 'internal:hide_objects', diff

    shoot: (event) ->
      position = @view.page_coords_to_game([event.pageX, event.pageY])
      payload = new GamePayload
        subtype: 'shoot'
        data: position
      Chaplin.mediator.send_to_server(payload)
