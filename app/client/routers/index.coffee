class App.Routers.Index extends Backbone.Router

  _.extend @prototype, Backbone.FrameManager

  frames:
    ''                : App.Views.Index

  initialize: ->
