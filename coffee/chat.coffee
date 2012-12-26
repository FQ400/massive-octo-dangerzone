class Chat
  
  @addMessage: (data) ->
    msg = data['data']
    $('#chat-content').append("<p>#{ msg }</p>")
    # scroll to bottom
    $('#chat-content').scrollTop($('#chat-content').height(), 0)
