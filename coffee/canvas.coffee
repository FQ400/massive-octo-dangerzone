class Canvas

  constructor: (element) ->
    @canvas = element
    @context = @canvas.getContext('2d')
  
  draw_user: (user) ->
    @filled_circle(user.position, 5)

  filled_circle: (pos, radius) ->
    @context.beginPath()
    @context.arc(pos[0], pos[1], radius, 0, 2*Math.PI)
    @context.fill()

  clear: ->
    @context.clearRect(0, 0, 640, 480)
