var TrackerApp;

TrackerApp = (function() {

  TrackerApp.prototype.options = {
    timeout: 100,
    ws_host: 'ws://localhost:9020'
  };

  function TrackerApp(opts) {
    var _this = this;
    $.extend(this.options, opts);
    this.socket = new WebSocket(this.options.ws_host);
    this.socket.onopen = function() {
      return _this.bind_tracking_events();
    };
    this.socket.onmessage = function(msg) {
      return _this.output(msg);
    };
    this.socket_id = 'socket_' + new Date().getTime();
    this.idle = true;
    setInterval(function() {
      return _this.idle = true;
    }, this.options.timeout);
  }

  TrackerApp.prototype.bind_tracking_events = function() {
    var _this = this;
    return $(document).on('mousemove click', function(event) {
      if (event.type === 'click') _this.send_msg(event);
      if (_this.idle === true && event.type === 'mousemove') {
        _this.send_msg(event);
        return _this.idle = false;
      }
    });
  };

  TrackerApp.prototype.send_msg = function(event) {
    return this.socket.send([event.pageX, event.pageY, new Date().getTime(), event.type, this.socket_id]);
  };

  TrackerApp.prototype.chat_msg = function(msg) {
    return this.socket.send(msg);
  };

  TrackerApp.prototype.output = function(msg) {
    $('#chat').append('<span>' + msg.data + '</span><br/>');
    return console.log(msg);
  };

  return TrackerApp;

})();

window.onload += new TrackerApp();
