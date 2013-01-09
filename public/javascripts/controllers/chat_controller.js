var __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

define(['chaplin', 'views/chat_view', 'models/chat', 'models/chat_payload'], function(Chaplin, ChatView, Chat, ChatPayload) {
  'use strict';
  var ChatController;
  return ChatController = (function(_super) {

    __extends(ChatController, _super);

    function ChatController() {
      ChatController.__super__.constructor.apply(this, arguments);
    }

    ChatController.prototype.initialize = function() {
      ChatController.__super__.initialize.apply(this, arguments);
      this.subscribeEvent('internal:send_chat_message', this.send_message);
      return Chaplin.mediator.subscribe('chat:new_message', this.new_message);
    };

    ChatController.prototype.show = function(params) {
      this.model = new Chat();
      return this.view = new ChatView({
        model: this.model
      });
    };

    ChatController.prototype.new_message = function(data) {
      var msg;
      msg = data.message;
      $('#chat-content').append("<p>" + msg + "</p>");
      return $('#chat-content').scrollTop($('#chat-content').height(), 0);
    };

    ChatController.prototype.send_message = function(message) {
      var payload;
      if (message) {
        payload = new ChatPayload({
          data: {
            message: message
          },
          subtype: 'public_message'
        });
        return Chaplin.mediator.send_to_server(payload);
      }
    };

    return ChatController;

  })(Chaplin.Controller);
});
