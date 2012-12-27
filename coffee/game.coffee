class Game

  options:
    timeout   : 100
    ws_host   : 'ws://localhost:9020'
    name      : 'fnord'

  constructor: (opts) ->
    # overwrite default options
    $.extend(@options, opts)

    @pubsub = new Mediator()
    @subscribeToChannels(@pubsub)

    @users = []
    @chat = new Chat()
    @canvas = new Canvas(document.getElementById('game_canvas'))
    @initialized = false

    @ws = new WebSocket(@options.ws_host)
    @ws.onopen = => @openCallback()
    @ws.onerror = => @error()
    @ws.onclose = => @close()
    @ws.onmessage = (msg) => @messageCallback(msg)

  subscribeToChannels: (mediator, data) ->
    mediator.Subscribe 'chat:new_message', (data) =>
      @chat.addMessage(data)

    mediator.Subscribe 'user:created', (data) =>
      name = data.data
      @user_created(name)

    mediator.Subscribe 'object:created', (data) =>
      id = data.id
      data = data.data
      @object_created(id, data)

    mediator.Subscribe 'user:deleted', (data) =>
      name = data.data
      @user_deleted(name)

    mediator.Subscribe 'object:deleted', (data) =>
      id = data.id
      @object_deleted(id)

    mediator.Subscribe 'game:join', (data) =>
      @user_join(data.data.user)

    mediator.Subscribe 'game:leave', (data) =>
      @user_leave(data.data.user)

    mediator.Subscribe 'game:init', (data) =>
      @init_state(data)

    mediator.Subscribe 'game:state', (data) =>
      @update_state(data)

  openCallback: ->
    payload = new WSPayload
      data:
        name: @options.name

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

    @pubsub.Publish([data['type'], data['subtype']].join(':'), data)

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

  user_created: (name) ->
    console.log('created: ' + name)
    @users[name] = new User(name)

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

  init_state: (data) ->
    console.log(data)
    for name, user of data.data.users
      @users[name] = new User(name)
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
