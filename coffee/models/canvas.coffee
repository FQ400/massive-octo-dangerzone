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
      @objects_layer = new Kinetic.Layer()
      @stage.add(@users_layer)
      @stage.add(@objects_layer)
      Chaplin.mediator.subscribe 'internal:user_icon_ready', (user) => @update_icon(user)
      Chaplin.mediator.subscribe 'internal:update_users', (users) => @update_users(users)
      Chaplin.mediator.subscribe 'internal:update_objects', (objects) => @update_objects(objects)
      Chaplin.mediator.subscribe 'internal:update_positions', (users, objects) => @update_positions(users, objects)

    update_users: (users) ->
      @users = {}
      for name, user of users
        if user.icon_ready
          @set_user_icon(user)
        else
          @users[name] = @circle(5)
      @reset_users()

    update_objects: (objects) ->
      @objects = {}
      for id, obj of objects
        if obj.icon_ready
          @set_object_icon(@objects, obj)
        else
          @objects[id] = @circle(2, 'green')
      @reset_objects()

    image: (icon) ->
      i = @image_size
      ratio = icon.width / icon.height
      [width, height] = if ratio > 1 then [@i, @i / ratio] else [i * ratio, i]
      new Kinetic.Image({image: icon, width: width, height: height, offset: [width/2, height/2]})

    circle: (radius, color='red') ->
      new Kinetic.Circle({radius: radius, fill: color, stroke: 'black'})

    update_positions: (users, objects) ->
      for name, user of users
        pos = user.position
        @users[name].setPosition(pos[0], pos[1])
        @users[name].setRotation(user.angle)
      for id, obj of objects
        pos = obj.position
        @objects[id].setPosition(pos[0], pos[1])
      @users_layer.draw()
      @objects_layer.draw()

    set_user_icon: (user) ->
      @users[user.name] = @image(user.icon)

    set_object_icon: (obj) ->
      @objects[id] = @image(obj.icon)

    update_icon: (user) ->
      @set_user_icon(user)
      @reset_users()

    reset_users: ->
      @users_layer.removeChildren()
      for name, user of @users
        @users_layer.add(user)

    reset_objects: ->
      @objects_layer.removeChildren()
      for name, obj of @objects
        @objects_layer.add(obj)
