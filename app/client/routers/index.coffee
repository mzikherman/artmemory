class App.Routers.Index extends Backbone.Router

  routes:
    '/'	:	'loadGame'

  loadGame: =>
    App.Views.ArtworkLayout