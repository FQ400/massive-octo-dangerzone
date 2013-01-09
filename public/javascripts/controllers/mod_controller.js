var __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

define(['chaplin', 'views/mod_view', 'models/mod', 'controllers/game_controller', 'controllers/chat_controller', 'controllers/menu_controller', 'controllers/input_controller'], function(Chaplin, MODView, MoD, GameController, ChatController, MenuController, InputController) {
  'use strict';
  var MODController;
  return MODController = (function(_super) {

    __extends(MODController, _super);

    function MODController() {
      MODController.__super__.constructor.apply(this, arguments);
    }

    MODController.prototype.show = function(params) {
      this.model = new MoD();
      this.view = new MODView({
        model: this.model
      });
      return this.subscribeEvent('internal:start', this.initialize_game_and_chat);
    };

    MODController.prototype.initialize_game_and_chat = function(data) {
      this.game = new GameController;
      this.game.show({
        name: data.name,
        icon: data.icon,
        ws_host: data.host
      });
      this.chat = new ChatController;
      this.chat.show();
      this.menu = new MenuController;
      this.menu.show();
      return this.input = new InputController;
    };

    return MODController;

  })(Chaplin.Controller);
});
