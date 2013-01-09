var __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

define(['chaplin', 'views/base/view', 'text!templates/mod.hbs'], function(Chaplin, View, template) {
  'use strict';
  var MODView;
  return MODView = (function(_super) {

    __extends(MODView, _super);

    function MODView() {
      MODView.__super__.constructor.apply(this, arguments);
    }

    MODView.prototype.template = template;

    MODView.prototype.className = 'mod';

    MODView.prototype.container = '#menu-container';

    MODView.prototype.autoRender = true;

    MODView.prototype.initialize = function() {
      MODView.__super__.initialize.apply(this, arguments);
      return this.delegate('click', '#start-game', this.setup);
    };

    MODView.prototype.setup = function(event) {
      var host, icon, name;
      event.preventDefault();
      name = $('#username').val();
      icon = $('#icon').val();
      host = $('#host').val();
      if (name) {
        return this.publishEvent('internal:start', {
          name: name,
          icon: icon,
          host: host
        });
      }
    };

    return MODView;

  })(View);
});
