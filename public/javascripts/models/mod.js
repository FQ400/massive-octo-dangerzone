var __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

define(['chaplin'], function(Chaplin) {
  'use strict';
  var MoD;
  return MoD = (function(_super) {

    __extends(MoD, _super);

    function MoD() {
      MoD.__super__.constructor.apply(this, arguments);
    }

    MoD.prototype.defaults = {
      username: 'default',
      icon: 'http://www.gamesaktuell.de/screenshots/970x546/2012/04/Trollfaces-Kompendium_-_Me_Gusta_Guy.JPG',
      host: 'ws://localhost:9020'
    };

    return MoD;

  })(Chaplin.Model);
});
