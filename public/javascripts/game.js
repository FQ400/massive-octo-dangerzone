var Game;

Game = (function() {

  Game.prototype.options = {
    timeout: 100,
    ws_host: 'ws://localhost:9020'
  };

  function Game(opts, mediator) {
    var _this = this;
    $.extend(this.options, opts);
    this.pubsub = new Mediator();
    this.ws = new WebSocket(this.options.ws_host);
    this.ws.onopen = function() {
      var payload;
      payload = new ChatPayload({
        subtype: 'new_message'
      });
      payload.data = "Hallo Torsten. :)";
      console.log(new WSPayload({
        subtype: 'open'
      }).type());
      _this.ws.send(new WSPayload({
        subtype: 'open'
      }).stringify());
      return _this.ws.send("Hi Server2");
    };
    this.ws.onmessage = function(msg) {
      var data;
      data = JSON.parse(msg);
      return console.log(data.type);
    };
    this.ws.onerror = function() {
      return _this.error();
    };
    this.ws.onclose = function() {
      return _this.close();
    };
  }

  Game.prototype.error = function() {
    return console.log(new WSPayload({
      subtype: 'error'
    }).type());
  };

  Game.prototype.close = function() {
    return console.log(new WSPayload({
      subtype: 'close'
    }).type());
  };

  return Game;

})();
