var __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

define(['chaplin', 'models/game_payload', 'views/configuration_view'], function(Chaplin, GamePayload, ConfigurationView) {
  'use strict';
  var InputController;
  return InputController = (function(_super) {

    __extends(InputController, _super);

    function InputController() {
      InputController.__super__.constructor.apply(this, arguments);
    }

    InputController.prototype.initialize = function(params) {
      var _this = this;
      InputController.__super__.initialize.apply(this, arguments);
      this.keys = {
        65: 'left',
        87: 'up',
        68: 'right',
        83: 'down'
      };
      this.subscribeEvent('internal:canvas_keydown', function(code) {
        return _this.key('down', code);
      });
      this.subscribeEvent('internal:canvas_keyup', function(code) {
        return _this.key('up', code);
      });
      this.subscribeEvent('internal:canvas_mouse_move', function(coords) {
        return _this.calc_angle(coords);
      });
      this.subscribeEvent('internal:game-configuration', this.open_config);
      return this.subscribeEvent('internal:map_key', function(data) {
        return _this.configure(data.key, data.code);
      });
    };

    InputController.prototype.key = function(type, code) {
      if (this.keys[code]) return this.send('key' + type, this.keys[code]);
    };

    InputController.prototype.calc_angle = function(coords) {
      var mx, my, p_pos, px, py, theta;
      if (!Chaplin.mediator.user) return;
      p_pos = Chaplin.mediator.user.position;
      mx = coords[0];
      my = coords[1];
      px = p_pos[0];
      py = p_pos[1];
      theta = Math.atan2(px - mx, py - my);
      if (theta) return this.send('rotate', theta);
    };

    InputController.prototype.send = function(type, key) {
      var payload;
      payload = new GamePayload({
        subtype: type,
        data: key
      });
      return Chaplin.mediator.send_to_server(payload);
    };

    InputController.prototype.configure = function(key, code) {
      var old_code;
      old_code = _.invert(this.keys)[key];
      delete this.keys[old_code];
      return this.keys[code] = key;
    };

    InputController.prototype.open_config = function() {
      return this.config_view = new ConfigurationView();
    };

    return InputController;

  })(Chaplin.Controller);
});
