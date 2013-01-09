var __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

define(['models/ws_payload'], function(WSPayload) {
  'use strict';
  var GamePayload;
  return GamePayload = (function(_super) {

    __extends(GamePayload, _super);

    function GamePayload() {
      GamePayload.__super__.constructor.apply(this, arguments);
    }

    GamePayload.prototype.options = {
      type: 'game'
    };

    return GamePayload;

  })(WSPayload);
});
