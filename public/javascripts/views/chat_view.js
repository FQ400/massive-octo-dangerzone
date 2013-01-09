var __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

define(['views/base/view', 'text!templates/chat.hbs'], function(View, template) {
  'use strict';
  var ChatView;
  return ChatView = (function(_super) {

    __extends(ChatView, _super);

    function ChatView() {
      ChatView.__super__.constructor.apply(this, arguments);
    }

    ChatView.prototype.template = template;

    ChatView.prototype.className = 'chat';

    ChatView.prototype.container = '#chat';

    ChatView.prototype.autoRender = true;

    ChatView.prototype.afterRender = function() {
      var _this = this;
      ChatView.__super__.afterRender.apply(this, arguments);
      this.delegate('click', '#chat-submit', function(event) {
        var message;
        event.preventDefault();
        message = $('#chat-msg-input').val();
        if (message) {
          _this.publishEvent('internal:send_chat_message', message);
          return $('#chat-msg-input').val('');
        }
      });
      return this.delegate('keyup', function(event) {
        var message;
        message = $('#chat-msg-input').val();
        if ($('#chat-msg-input').is(':focus') && event.keyCode === 13 && message) {
          _this.publishEvent('internal:send_chat_message', message);
          return $('#chat-msg-input').val('');
        }
      });
    };

    return ChatView;

  })(View);
});
