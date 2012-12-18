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
    console.log(this.options);
    this.ws = new WebSocket(this.options.ws_host);
    this.ws.onopen = function() {
      var payload;
      payload = new WSPayload({
        data: {
          name: _this.options.name
        }
      });
      return _this.ws.send(payload.stringify());
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
