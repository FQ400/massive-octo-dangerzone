var ChatPayload, WSPayload,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

WSPayload = (function() {

  WSPayload.prototype.options = {
    type: 'socket',
    subtype: 'init'
  };

  function WSPayload(opts) {
    $.extend(this.options, opts);
  }

  WSPayload.prototype.type = function() {
    return [this.options.type, this.options.subtype].join(':');
  };

  WSPayload.prototype.stringify = function() {
    return JSON.stringify({
      type: this.options.type,
      subtype: this.options.subtype,
      data: this.options.data
    });
  };

  return WSPayload;

})();

ChatPayload = (function(_super) {

  __extends(ChatPayload, _super);

  ChatPayload.prototype.options = {
    type: 'chat'
  };

  function ChatPayload(opts) {
    ChatPayload.__super__.constructor.apply(this, arguments);
  }

  return ChatPayload;

})(WSPayload);
