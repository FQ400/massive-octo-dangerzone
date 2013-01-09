var __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

define(['views/base/view', 'text!templates/game.hbs', 'models/canvas'], function(View, template, Canvas) {
  'use strict';
  var GameView;
  return GameView = (function(_super) {

    __extends(GameView, _super);

    function GameView() {
      GameView.__super__.constructor.apply(this, arguments);
    }

    GameView.prototype.template = template;

    GameView.prototype.className = 'game';

    GameView.prototype.container = '#canvas-container';

    GameView.prototype.autoRender = true;

    GameView.prototype.afterRender = function() {
      var _this = this;
      GameView.__super__.afterRender.apply(this, arguments);
      this.idle = true;
      setInterval(function() {
        return _this.idle = true;
      }, 50);
      this.subscribeEvent('internal:rebind_keys', this.rebind_keys);
      this.bind_keys();
      return this.canvas = new Canvas(document.getElementById('game_canvas'));
    };

    GameView.prototype.page_coords_to_game = function(pos) {
      var total_offset;
      total_offset = $('#' + this.canvas.id).position();
      return [pos[0] - total_offset.left, pos[1] - total_offset.top];
    };

    GameView.prototype.bind_keys = function() {
      var _this = this;
      this.delegate('keydown', '#game_canvas', function(event) {
        return _this.publishEvent('internal:canvas_keydown', event.keyCode);
      });
      this.delegate('keyup', '#game_canvas', function(event) {
        return _this.publishEvent('internal:canvas_keyup', event.keyCode);
      });
      this.delegate('click', function(event) {
        return _this.publishEvent('internal:shoot', event);
      });
      return this.delegate('mousemove', '#game_canvas', function(event) {
        if (_this.idle) {
          _this.publishEvent('internal:canvas_mouse_move', _this.page_coords_to_game([event.pageX, event.pageY]));
          return _this.idle = false;
        }
      });
    };

    GameView.prototype.rebind_keys = function() {
      this.undelegate();
      return this.bind_keys();
    };

    return GameView;

  })(View);
});
