class User

  constructor: (name, icon, position) ->
    @name = name
    if icon
      @icon = new Image()
      @icon.src = icon
    else
      icon = null
    @position = position

  set_position: (pos) ->
    @position = pos
