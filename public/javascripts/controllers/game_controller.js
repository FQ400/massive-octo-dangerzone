var __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

define(['chaplin', 'views/game_view', 'models/game', 'controllers/chat_controller', 'models/game_payload', 'models/user', 'models/game_object'], function(Chaplin, GameView, Game, ChatController, GamePayload, User, GameObject) {
  'use strict';
  var GameController;
  return GameController = (function(_super) {

    __extends(GameController, _super);

    function GameController() {
      GameController.__super__.constructor.apply(this, arguments);
      this.users = {};
      this.objects = {};
      this.initialized = false;
      this.subscribe_to_channels();
    }

    GameController.prototype.subscribe_to_channels = function() {
      var mediator,
        _this = this;
      mediator = Chaplin.mediator;
      this.subscribeEvent('internal:game-join', this.join);
      this.subscribeEvent('internal:game-leave', this.leave);
      mediator.subscribe('user:deleted', function(data) {
        var name;
        name = data.data;
        return _this.user_deleted(name);
      });
      mediator.subscribe('game:join', function(data) {
        return _this.user_join(data.user);
      });
      mediator.subscribe('game:leave', function(data) {
        return _this.user_leave(data.user);
      });
      mediator.subscribe('game:init', function(data) {
        return _this.init_state(data.id);
      });
      mediator.subscribe('game:state', function(data) {
        return _this.update_state(data);
      });
      mediator.subscribe('game:user_list', function(data) {
        return _this.user_list(data);
      });
      mediator.subscribe('game:object_list', function(data) {
        return _this.object_list(data);
      });
      mediator.subscribe('game:objects_created', function(data) {
        return _this.objects_created(data);
      });
      mediator.subscribe('game:objects_deleted', function(data) {
        return _this.objects_deleted(data);
      });
      return mediator.subscribe('internal:shoot', function(data) {
        return _this.shoot(data);
      });
    };

    GameController.prototype.show = function(params) {
      Chaplin.mediator.game = this.model = new Game(params);
      return this.view = new GameView({
        model: this.model
      });
    };

    GameController.prototype.join = function() {
      var payload;
      payload = new GamePayload({
        subtype: 'join'
      });
      Chaplin.mediator.send_to_server(payload);
      return $('#game_canvas').focus();
    };

    GameController.prototype.leave = function() {
      var payload;
      payload = new GamePayload({
        subtype: 'leave'
      });
      Chaplin.mediator.send_to_server(payload);
      return this.initialized = false;
    };

    GameController.prototype.user_join = function(user) {
      Chaplin.mediator.user = this.users[this.user_id];
      return console.log("join: " + user);
    };

    GameController.prototype.user_leave = function(user) {
      return console.log("leave: " + user);
    };

    GameController.prototype.user_list = function(data) {
      var user, _i, _len, _ref;
      this.users = {};
      _ref = data.users;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        user = _ref[_i];
        this.users[user.name] = new User(user.id, user.icon, user.position, user.name);
      }
      return Chaplin.mediator.publish('internal:update_users', this.users);
    };

    GameController.prototype.objects_created = function(data) {
      var obj, objects, _i, _len, _ref;
      objects = [];
      _ref = data.objects;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        obj = _ref[_i];
        this.objects[obj.id] = new GameObject(obj.id, obj.icon, obj.position, obj.size);
        objects.push(this.objects[obj.id]);
      }
      return Chaplin.mediator.publish('internal:objects_created', objects);
    };

    GameController.prototype.objects_deleted = function(data) {
      var obj, objects, _i, _len, _ref;
      objects = [];
      _ref = data.objects;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        obj = _ref[_i];
        delete this.objects[obj.id];
      }
      return Chaplin.mediator.publish('internal:objects_deleted', data.objects);
    };

    GameController.prototype.user_deleted = function(name) {
      if (this.users[name]) {
        console.log('deleted: ' + name);
        return delete this.users[name];
      }
    };

    GameController.prototype.init_state = function(id) {
      this.user_id = id;
      Chaplin.mediator.user = this.objects[this.user_id];
      return this.initialized = true;
    };

    GameController.prototype.update_state = function(data) {
      if (this.initialized) {
        return this.update_positions(data.positions, data.angles, data.sizes);
      }
    };

    GameController.prototype.update_positions = function(positions, angles, sizes) {
      var obj, _i, _j, _k, _len, _len2, _len3;
      for (_i = 0, _len = angles.length; _i < _len; _i++) {
        obj = angles[_i];
        this.objects[obj.id].angle = obj.angle;
      }
      for (_j = 0, _len2 = positions.length; _j < _len2; _j++) {
        obj = positions[_j];
        this.objects[obj.id].position = obj.position;
      }
      for (_k = 0, _len3 = sizes.length; _k < _len3; _k++) {
        obj = sizes[_k];
        this.objects[obj.id].size = obj.size;
      }
      return Chaplin.mediator.publish('internal:update_positions', this.objects);
    };

    GameController.prototype.shoot = function(event) {
      var payload, position;
      position = this.view.page_coords_to_game([event.pageX, event.pageY]);
      payload = new GamePayload({
        subtype: 'shoot',
        data: position
      });
      return Chaplin.mediator.send_to_server(payload);
    };

    return GameController;

  })(Chaplin.Controller);
});
