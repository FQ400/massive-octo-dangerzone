define [
  'chaplin'
  'kinetic'
], (Chaplin, Kinetic) ->
  'use strict'

  class Canvas extends Chaplin.Model
    container: 'game_canvas'

    constructor: (element) ->
      super
      @objects = {}
      @image_size = 60
      @stage = new Kinetic.Stage({container: @container, width: 640, height: 480})
      @objects_layer = new Kinetic.Layer()
      @stage.add(@objects_layer)
      Chaplin.mediator.subscribe 'internal:user_icon_ready', (user) => @update_icon(user)
      Chaplin.mediator.subscribe 'internal:update_users', (users) => @update_users(users)
      Chaplin.mediator.subscribe 'internal:update_objects', (objects) => @update_objects(objects)
      Chaplin.mediator.subscribe 'internal:objects_created', (objects) => @objects_created(objects)
      Chaplin.mediator.subscribe 'internal:objects_deleted', (objects) => @objects_deleted(objects)
      Chaplin.mediator.subscribe 'internal:update_positions', (users, objects) => @update_positions(users, objects)

    objects_created: (objects) ->
      for obj in objects
        if obj.icon_ready
          @set_icon(obj)
        else
          @objects[obj.id] = @circle(2, 'green')
          @objects_layer.add(@objects[obj.id])
      @objects_layer.draw()

    objects_deleted: (objects) ->
      for obj in objects
        @delete_object(obj)
      @objects_layer.draw()

    delete_object: (obj) ->
      @objects[obj.id].remove()
      delete @objects[obj.id]

    image: (icon, i) ->
      if i > 0
        [width, height] = @calculate_size(icon.width, icon.height, i)
      else
        [width, height] = [icon.width, icon.height]
      new Kinetic.Image({image: icon, width: width, height: height, offset: [width/2, height/2]})

    circle: (radius, color='red') ->
      new Kinetic.Circle({radius: radius, fill: color, stroke: 'black'})

    update_positions: (objects) ->
      for id, obj of objects
        pos = obj.position
        @objects[obj.id].setPosition(pos[0], pos[1])
        @objects[obj.id].setRotation(obj.angle)
        [width, height] = @calculate_size(@objects[obj.id].getWidth(), @objects[obj.id].getHeight(), obj.size)
        @objects[obj.id].setHeight(height)
        @objects[obj.id].setWidth(width)
        @objects[obj.id].setOffset([width/2, height/2])
      @objects_layer.draw()

    set_icon: (obj) ->
      @objects[obj.id] = @image(obj.icon, obj.size)
      @objects_layer.add(@objects[obj.id])

    update_icon: (obj) ->
      @delete_object(obj)
      @set_icon(obj)
      @objects_layer.draw()
    
    calculate_size: (width, height, size) ->
        ratio = width / height
        if ratio > 1 then [size, size / ratio] else [size * ratio, size]
