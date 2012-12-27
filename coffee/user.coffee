class User

  constructor: (name) ->
    @name = name
    @position = [0, 0]

  set_position: (pos) ->
    @position = pos
