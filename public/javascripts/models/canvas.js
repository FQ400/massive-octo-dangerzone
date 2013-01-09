var __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

define(['chaplin', 'kinetic'], function(Chaplin, Kinetic) {
  'use strict';
  var Canvas;
  return Canvas = (function(_super) {

    __extends(Canvas, _super);

    Canvas.prototype.container = 'game_canvas';

    function Canvas(element) {
      var _this = this;
      Canvas.__super__.constructor.apply(this, arguments);
      this.objects = {};
      this.image_size = 60;
      this.stage = new Kinetic.Stage({
        container: this.container,
        width: 640,
        height: 480
      });
      this.objects_layer = new Kinetic.Layer();
      this.stage.add(this.objects_layer);
      Chaplin.mediator.subscribe('internal:user_icon_ready', function(user) {
        return _this.update_icon(user);
      });
      Chaplin.mediator.subscribe('internal:update_users', function(users) {
        return _this.update_users(users);
      });
      Chaplin.mediator.subscribe('internal:update_objects', function(objects) {
        return _this.update_objects(objects);
      });
      Chaplin.mediator.subscribe('internal:objects_created', function(objects) {
        return _this.objects_created(objects);
      });
      Chaplin.mediator.subscribe('internal:objects_deleted', function(objects) {
        return _this.objects_deleted(objects);
      });
      Chaplin.mediator.subscribe('internal:update_positions', function(users, objects) {
        return _this.update_positions(users, objects);
      });
    }

    Canvas.prototype.objects_created = function(objects) {
      var obj, _i, _len;
      for (_i = 0, _len = objects.length; _i < _len; _i++) {
        obj = objects[_i];
        if (obj.icon_ready) {
          this.set_icon(obj);
        } else {
          this.objects[obj.id] = this.circle(2, 'green');
          this.objects_layer.add(this.objects[obj.id]);
        }
      }
      return this.objects_layer.draw();
    };

    Canvas.prototype.objects_deleted = function(objects) {
      var obj, _i, _len;
      for (_i = 0, _len = objects.length; _i < _len; _i++) {
        obj = objects[_i];
        this.delete_object(obj);
      }
      return this.objects_layer.draw();
    };

    Canvas.prototype.delete_object = function(obj) {
      this.objects[obj.id].remove();
      return delete this.objects[obj.id];
    };

    Canvas.prototype.image = function(icon, i) {
      var height, width, _ref, _ref2;
      if (i > 0) {
        _ref = this.calculate_size(icon.width, icon.height, i), width = _ref[0], height = _ref[1];
      } else {
        _ref2 = [icon.width, icon.height], width = _ref2[0], height = _ref2[1];
      }
      return new Kinetic.Image({
        image: icon,
        width: width,
        height: height,
        offset: [width / 2, height / 2]
      });
    };

    Canvas.prototype.circle = function(radius, color) {
      if (color == null) color = 'red';
      return new Kinetic.Circle({
        radius: radius,
        fill: color,
        stroke: 'black'
      });
    };

    Canvas.prototype.update_positions = function(objects) {
      var height, id, obj, pos, width, _ref;
      for (id in objects) {
        obj = objects[id];
        pos = obj.position;
        this.objects[obj.id].setPosition(pos[0], pos[1]);
        this.objects[obj.id].setRotation(obj.angle);
        _ref = this.calculate_size(this.objects[obj.id].getWidth(), this.objects[obj.id].getHeight(), obj.size), width = _ref[0], height = _ref[1];
        this.objects[obj.id].setHeight(height);
        this.objects[obj.id].setWidth(width);
        this.objects[obj.id].setOffset([width / 2, height / 2]);
      }
      return this.objects_layer.draw();
    };

    Canvas.prototype.set_icon = function(obj) {
      this.objects[obj.id] = this.image(obj.icon, obj.size);
      return this.objects_layer.add(this.objects[obj.id]);
    };

    Canvas.prototype.update_icon = function(obj) {
      this.delete_object(obj);
      this.set_icon(obj);
      return this.objects_layer.draw();
    };

    Canvas.prototype.calculate_size = function(width, height, size) {
      var ratio;
      ratio = width / height;
      if (ratio > 1) {
        return [size, size / ratio];
      } else {
        return [size * ratio, size];
      }
    };

    return Canvas;

  })(Chaplin.Model);
});
