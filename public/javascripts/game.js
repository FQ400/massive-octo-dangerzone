// Generated by CoffeeScript 1.4.0
var Game;

Game = (function() {

  Game.prototype.options = {
    timeout: 100,
    ws_host: 'ws://localhost:9020',
    name: 'fnord'
  };

  function Game(opts) {
    var _this = this;
    $.extend(this.options, opts);
    this.pubsub = new Mediator();
    this.subscribeToChannels(this.pubsub);
    this.users = [];
    this.ws = new WebSocket(this.options.ws_host);
    this.ws.onopen = function() {
      return _this.openCallback();
    };
    this.ws.onerror = function() {
      return _this.error();
    };
    this.ws.onclose = function() {
      return _this.close();
    };
    this.ws.onmessage = function(msg) {
      return _this.messageCallback(msg);
    };
  }

  Game.prototype.subscribeToChannels = function(mediator, data) {
    var _this = this;
    mediator.Subscribe('chat:new_message', function(data) {
      return Chat.addMessage(data);
    });
    return mediator.Subscribe('user:created', function(data) {
      return User.create(data);
    });
  };

  Game.prototype.openCallback = function() {
    var payload;
    payload = new WSPayload({
      data: {
        name: this.options.name
      }
    });
    return this.ws.send(payload.stringify());
  };

  Game.prototype.error = function() {
    return console.log("There was an Error.");
  };

  Game.prototype.close = function() {
    return console.log("Socket closed.");
  };

  Game.prototype.messageCallback = function(msg) {
    var data;
    try {
      data = JSON.parse(msg.data);
    } catch (error) {
      console.log(error);
      return false;
    }
    return this.pubsub.Publish([data['type'], data['subtype']].join(':'), data);
  };

  return Game;

})();
