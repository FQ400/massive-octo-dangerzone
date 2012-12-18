var GameApp;

GameApp = (function() {

  function GameApp() {
    this.bind_page_events();
  }

  GameApp.prototype.bind_page_events = function() {
    var _this = this;
    return $('#start-game').on('click', function(event) {
      var game;
      event.preventDefault();
      return game = new Game({
        name: $('#username').val()
      });
    });
  };

  return GameApp;

})();
