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
    @$el.packery({
      columnWidth: 80,
      rowHeight: 80
    })
    $items = @$el.find('.item')
    $items.draggable()
    @$el.packery('bindUIDraggableEvents', $items)
      