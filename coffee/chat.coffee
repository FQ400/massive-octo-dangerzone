class Chat

  constructor: ->
    @messages = []

  addMessage: (data) ->
    msg = data['data']
    @messages.push("<p>#{msg}</p>")
    $('#chat-messages').html(@messages[-10..].join(''))
