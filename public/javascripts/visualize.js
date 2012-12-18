var VizApp;

VizApp = (function() {

  VizApp.prototype.options = {
    ws_host: 'ws://localhost:9020'
  };

  VizApp.prototype.clients = {};

  function VizApp() {
    var _this = this;
    $('#canvas-container').css({
      width: $(document).width() + 'px',
      height: $(document).height() + 'px'
    });
    ClientViz.stage = new Kinetic.Stage({
      container: 'canvas-container',
      width: $(document).width(),
      height: $(document).height()
    });
    this.socket = new WebSocket(this.options.ws_host + '?viz=1');
    this.socket.onmessage = function(msg) {
      var client;
      client = _this.clients[VizSupport.client_id(msg.data)];
      if (client) {
        return client.draw_points(msg.data);
      } else {
        return _this.clients[VizSupport.client_id(msg.data)] = new ClientViz(msg.data);
      }
    };
  }

  return VizApp;

})();

window.onload += new VizApp();
