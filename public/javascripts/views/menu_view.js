var __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

define(['chaplin', 'views/base/view', 'text!templates/menu.hbs'], function(Chaplin, View, template) {
  'use strict';
  var MenuView;
  return MenuView = (function(_super) {

    __extends(MenuView, _super);

    function MenuView() {
      MenuView.__super__.constructor.apply(this, arguments);
    }

    MenuView.prototype.template = template;

    MenuView.prototype.className = 'menu';

    MenuView.prototype.container = '#menu-container';

    MenuView.prototype.containerMethod = 'html';

    MenuView.prototype.autoRender = true;

    MenuView.prototype.initialize = function() {
      var _this = this;
      this.delegate('click', '#join-game', function(event) {
        event.preventDefault();
        _this.publishEvent('internal:game-join');
        $('#join-game').hide();
        return $('#leave-game').show();
      });
      this.delegate('click', '#leave-game', function(event) {
        event.preventDefault();
        _this.publishEvent('internal:game-leave');
        $('#join-game').show();
        return $('#leave-game').hide();
      });
      this.delegate('click', '#configure-game', function(event) {
        event.preventDefault();
        return _this.publishEvent('internal:game-configuration');
      });
      return MenuView.__super__.initialize.apply(this, arguments);
    };

    MenuView.prototype.afterRender = function() {
      MenuView.__super__.afterRender.apply(this, arguments);
      return $('#leave-game').hide();
    };

    return MenuView;

  })(View);
});
