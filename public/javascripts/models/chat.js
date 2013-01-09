var __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

define(['chaplin'], function(Chaplin) {
  'use strict';
  var Chat;
  return Chat = (function(_super) {

    __extends(Chat, _super);

    function Chat() {
      Chat.__super__.constructor.apply(this, arguments);
    }

    Chat.prototype.defaults = {
      width: 640,
      height: 480
    };

    return Chat;

  })(Chaplin.Model);
});
