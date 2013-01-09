var __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

define(['chaplin'], function(Chaplin) {
  'use strict';
  var GameObject;
  return GameObject = (function(_super) {

    __extends(GameObject, _super);

    GameObject.ICONS = {};

    function GameObject(id, icon, position, size) {
      GameObject.__super__.constructor.apply(this, arguments);
      this.id = id;
      this.position = position;
      this.icon_ready = false;
      this.set_icon(icon);
      this.angle = 0;
      this.size = size;
    }

    GameObject.prototype.set_icon = function(icon) {
      var _this = this;
      if (GameObject.ICONS[icon]) {
        this.icon = GameObject.ICONS[icon];
        return this.icon_ready = true;
      } else if (icon) {
        this.icon_ready = false;
        this.icon = new Image();
        this.icon.src = icon;
        return this.icon.onload = function() {
          _this.icon_ready = true;
          GameObject.ICONS[icon] = _this.icon;
          return Chaplin.mediator.publish('internal:user_icon_ready', _this);
        };
      } else {
        return icon = null;
      }
    };

    return GameObject;

  })(Chaplin.Model);
});
