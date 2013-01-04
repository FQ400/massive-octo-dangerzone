define [
  'chaplin'
  'kinetic'
], (Chaplin, Kinetic) ->
  'use strict'

  class Canvas extends Chaplin.Model
    container: 'game_canvas'

    constructor: (element) ->
      super
      @image_size = 60
      @stage = new Kinetic.Stage({container: @container, width: 640, height: 480})
      @users_layer = new Kinetic.Layer()
      @stage.add(@users_layer)
      Chaplin.mediator.subscribe 'internal:user_icon_ready', (user) => @update_icon(user)
      Chaplin.mediator.subscribe 'internal:update_users', (users) => @update_users(users)
      Chaplin.mediator.subscribe 'internal:update_positions', (users) => @update_positions(users)

    update_users: (users) ->
      @users = {}
      for name, user of users
        if user.icon_ready
          @set_icon(user)
        else
          @users[name] = @circle(5)
      @reset_users()

    image: (icon) ->
      i = @image_size
      ratio = icon.width / icon.height
      [width, height] = if ratio > 1 then [@i, @i / ratio] else [i * ratio, i]
      new Kinetic.Image({image: icon, width: width, height: height, offset: [width/2, height/2]})

    circle: (radius) ->
      new Kinetic.Circle({radius: radius, fill: 'red', stroke: 'black'})

    update_positions: (users) ->
      for name, user of users
        pos = user.position
        @users[name].setPosition(pos[0], pos[1])
      @users_layer.draw()

    set_icon: (user) ->
      @users[user.name] = @image(user.icon)

    update_icon: (user) ->
      @set_icon(user)
      @reset_users()

    reset_users: ->
      @users_layer.removeChildren()
      for name, user of @users
        @users_layer.add(user)
