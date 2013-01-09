var __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

define(['chaplin', 'routes'], function(Chaplin, routes) {
  'use strict';
  var MODApplication;
  return MODApplication = (function(_super) {

    __extends(MODApplication, _super);

    function MODApplication() {
      MODApplication.__super__.constructor.apply(this, arguments);
    }

    MODApplication.prototype.title = 'Massive Octo Dangerzone';

    MODApplication.prototype.initialize = function() {
      MODApplication.__super__.initialize.apply(this, arguments);
      this.initDispatcher();
      this.initLayout();
      this.initRouter(routes);
      this.init_mediator();
      return typeof Object.freeze === "function" ? Object.freeze(this) : void 0;
    };

    MODApplication.prototype.init_mediator = function() {
      Chaplin.mediator.game = null;
      Chaplin.mediator.user = null;
      Chaplin.mediator.send_to_server = function(data) {
        return Chaplin.mediator.publish('server:send', data);
      };
      return Chaplin.mediator.seal();
    };

    return MODApplication;

  })(Chaplin.Application);
});
