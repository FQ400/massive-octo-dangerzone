class Chat
  
  @addMessage: (data) ->
    msg = data['data']
    $('#chat').prepend("<p>#{ msg }</p>")
    