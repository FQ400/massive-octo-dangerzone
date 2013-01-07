// Generated by CoffeeScript 1.4.0
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(['chaplin', 'views/base/view', 'text!templates/configuration.hbs'], function(Chaplin, View, template) {
  'use strict';

  var ConfigurationView;
  return ConfigurationView = (function(_super) {

    __extends(ConfigurationView, _super);

    function ConfigurationView() {
      return ConfigurationView.__super__.constructor.apply(this, arguments);
    }

    ConfigurationView.prototype.template = template;

    ConfigurationView.prototype.className = 'configuration';

    ConfigurationView.prototype.container = '#config-container';

    ConfigurationView.prototype.autoRender = true;

    ConfigurationView.prototype.assignment_in_progress = false;

    ConfigurationView.prototype.afterRender = function() {
      var _this = this;
      this.delegate('click', 'a.close', function(event) {
        event.preventDefault();
        _this.publishEvent('internal:rebind_keys');
        return _this.dispose();
      });
      this.delegate_key_binding_styles();
      return ConfigurationView.__super__.afterRender.apply(this, arguments);
    };

    ConfigurationView.prototype.delegate_key_binding_styles = function() {
      var _this = this;
      this.delegate('mouseover', '.key', function(event) {
        if (!_this.assignment_in_progress) {
          return $(event.target).addClass('shadow');
        } else {
          return false;
        }
      });
      this.delegate('mouseout', '.key', function(event) {
        if (!_this.assignment_in_progress) {
          return $(event.target).removeClass('shadow');
        } else {
          return false;
        }
      });
      this.delegate('focus', '.key', function(event) {
        _this.assignment_in_progress = true;
        return $(event.target).val('');
      });
      return this.delegate('keyup', '.key', function(event) {
        var id;
        if (_this.assignment_in_progress) {
          console.log(event.keyCode);
          id = $(event.target).attr('id');
          _this.publishEvent('internal:map_key', {
            'key': id,
            'code': event.keyCode
          });
          $(event.target).removeClass('shadow').blur();
          return _this.assignment_in_progress = false;
        } else {
          return false;
        }
      });
    };

    return ConfigurationView;

  })(View);
});