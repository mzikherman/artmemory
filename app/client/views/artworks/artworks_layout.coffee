class App.Views.ArtworksLayout extends Backbone.View
  
  el: '#container'
  
  initialize:(opts) ->
    @collection = opts.collection
    @render()

  render: =>
    html = ""
    for model in @collection.models
      html += JST['artworks/artwork_thumb'] model: model
    @$el.html(html)
      