class Chat

  constructor: ->
    @messages = []

  addMessage: (data) ->
    msg = data['data']
    $('#chat-content').append("<p>#{ msg }</p>")
    # scroll to bottom
    $('#chat-content').scrollTop($('#chat-content').height(), 0)
    @messages.push("<p>#{msg}</p>")
    $('#chat-messages').html(@messages[-10..].join(''))

