var __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

define(['chaplin'], function(Chaplin) {
  'use strict';
  var Menu;
  return Menu = (function(_super) {

    __extends(Menu, _super);

    function Menu() {
      Menu.__super__.constructor.apply(this, arguments);
    }

    Menu.prototype.defaults = {
      title: 'Massive Octo Dangerzone',
      items: [
        {
          id: 'join-game',
          href: '#join',
          title: 'Join'
        }, {
          id: 'leave-game',
          href: '#leave',
          title: 'Leave'
        }, {
          id: 'configure-game',
          href: 'configure',
          title: 'Configure'
        }
      ]
    };

    return Menu;

  })(Chaplin.Model);
});
