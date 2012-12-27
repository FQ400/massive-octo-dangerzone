class Canvas

  constructor: (element) ->
    @canvas = element
    @context = @canvas.getContext('2d')
    @image_size = 60
  
  draw_user: (user) ->
    if user.icon
      @image(user.position, user.icon)
    else
      @filled_circle(user.position, 5)

  filled_circle: (pos, radius) ->
    @context.beginPath()
    @context.arc(pos[0], pos[1], radius, 0, 2*Math.PI)
    @context.fill()

  clear: ->
    @context.clearRect(0, 0, 640, 480)

  image: (pos, icon) ->
    ratio = icon.width / icon.height
    if ratio > 1
      width = @image_size
      height = @image_size / ratio
    else
      height = @image_size
      width = @image_size * ratio
    @context.drawImage(icon, pos[0] + @image_size/2, pos[1] + @image_size/2, width, height)
