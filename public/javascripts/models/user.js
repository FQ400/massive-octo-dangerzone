var __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

define(['models/game_object'], function(GameObject) {
  'use strict';
  var User;
  return User = (function(_super) {

    __extends(User, _super);

    function User(id, icon, position, name) {
      User.__super__.constructor.call(this, id, icon, position);
      this.name = name;
    }

    return User;

  })(GameObject);
});
