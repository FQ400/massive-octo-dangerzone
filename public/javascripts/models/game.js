var __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
  __slice = Array.prototype.slice;

define(['chaplin', 'models/ws_payload'], function(Chaplin, WSPayload) {
  'use strict';
  var Game;
  return Game = (function(_super) {

    __extends(Game, _super);

    function Game() {
      Game.__super__.constructor.apply(this, arguments);
    }

    Game.prototype.options = {
      timeout: 100,
      ws_host: 'ws://localhost:9020',
      name: 'fnord',
      icon: null
    };

    Game.prototype.defaults = {
      width: 640,
      height: 480
    };

    Game.prototype.initialize = function(opts) {
      var key, keys,
        _this = this;
      keys = [
        (function() {
          var _i, _len, _ref, _results;
          _ref = _.keys(opts);
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            key = _ref[_i];
            if (opts[key]) _results.push(key);
          }
          return _results;
        })()
      ];
      $.extend(this.options, _.pick.apply(_, [opts].concat(__slice.call(keys))));
      this.ws = new WebSocket(this.options.ws_host);
      this.ws.onopen = function() {
        return _this.socket_opened();
      };
      this.ws.onerror = function() {
        return _this.error();
      };
      this.ws.onclose = function() {
        return _this.close();
      };
      return this.ws.onmessage = function(msg) {
        return _this.server_message(msg);
      };
    };

    Game.prototype.socket_opened = function() {
      var payload,
        _this = this;
      Chaplin.mediator.subscribe('server:send', function(data) {
        return _this.send_to_server(data);
      });
      payload = new WSPayload({
        data: {
          name: this.options.name,
          icon: this.options.icon
        }
      });
      return Chaplin.mediator.send_to_server(payload);
    };

    Game.prototype.error = function() {
      return console.log("There was an Error.");
    };

    Game.prototype.close = function() {
      return console.log("Socket closed.");
    };

    Game.prototype.server_message = function(msg) {
      var data;
      try {
        data = JSON.parse(msg.data);
        return Chaplin.mediator.publish([data['type'], data['subtype']].join(':'), data);
      } catch (error) {
        console.log(error);
        return false;
      }
    };

    Game.prototype.send_to_server = function(payload) {
      return this.ws.send(payload.stringify());
    };

    return Game;

  })(Chaplin.Model);
});
