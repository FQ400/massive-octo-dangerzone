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
      @stage = new Kinetic.Stage
        container: @container
        width: 800
        height: 600
      @objects_layer = new Kinetic.Layer()
      @stage.add(@objects_layer)

      Chaplin.mediator.subscribe 'internal:user_icon_ready', (user) => @update_icon(user)
      Chaplin.mediator.subscribe 'internal:update_objects', (objects) => @update_objects(objects)
      Chaplin.mediator.subscribe 'internal:hide_objects', (objects) => @hide_objects(objects)
      Chaplin.mediator.subscribe 'internal:objects_created', (objects) => @objects_created(objects)
      Chaplin.mediator.subscribe 'internal:objects_deleted', (objects) => @objects_deleted(objects)

      @setupHUD()

    setupHUD: ->
      @hudLayer = new Kinetic.Layer
        opacity: 0.6

      @stage.add(@hudLayer)
      @hp = new Kinetic.Text({
        x: 700
        y: 20
        text: "100/100"
        fontSize: 18
        fontStyle: 'bold'
        fill: 'red'
      })
      @hudLayer.add(@hp)
      @hudLayer.draw()


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

    image: (icon, size) ->
      if size > 0
        [width, height] = @calculate_size(icon.width, icon.height, size)
      else
        [width, height] = [icon.width, icon.height]
      new Kinetic.Image({image: icon, width: width, height: height, offset: [width/2, height/2]})

    circle: (radius, color='red') ->
      new Kinetic.Circle({radius: radius, fill: color, stroke: 'black'})

    update_objects: (objects) ->
      for id, obj of objects
        pos = obj.position
        kin_obj = @objects[obj.id]
        kin_obj.show()
        kin_obj.setPosition(pos[0], pos[1])
        kin_obj.setRotation(obj.angle)
        if kin_obj.shapeType == 'Image'
          [width, height] = @calculate_size(kin_obj.getWidth(), kin_obj.getHeight(), obj.size)
          kin_obj.setHeight(height)
          kin_obj.setWidth(width)
          kin_obj.setOffset([width/2, height/2])
      @objects_layer.draw()

    hide_objects: (objects) ->
      for id, obj of objects
        @objects[obj.id].hide()

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
