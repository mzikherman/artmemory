class App.Views.ArtworksLayout extends Backbone.View
  
  el: '#container'
  
  initialize:(opts) ->
    @collection = opts.collection
    @$container = @$el.find('#items_container')
    @$timer = @$el.find('#timer')
    @started = false
    @render()

  events:
    'click .start_guess_artwork' : 'beginGuessingGame'
    'click .start_memory': 'beginMemory'
    'click .item' : 'guess'
    'click a.skip': 'beginGuessingGame'

  removeFromGame:(e) =>
    @$container.packery('remove', $(e.currentTarget))
    @$container.packery() 

  guess:(e) =>
    model = @collection.get($(e.currentTarget).closest('.item').data('id'))
    if model.get('artist').name == @picked
      @removeFromGame(e)
      @collection.remove model
      @beginGuessingGame()
      @$('#wrong_guess').hide()
    else
      @$('#wrong_guess').show()

  render: =>
    html = ""
    for model in @collection.models
      html += JST['artworks/artwork_thumb'] model: model
    @$('#loading').hide()
    @$container.html(html)
    @$el.imagesLoaded =>
      @bindDraggable()

  bindDraggable: =>
    $items = @$container.find('.item')
    $items.draggable()
    @$container.packery({
      gutter: 40
    })
    @$container.packery('bindUIDraggableEvents', $items)

  beginMemory: =>
    


  beginGuessingGame: =>
    @picked = @collection.models[@generateRandom()].get('artist').name
    @$('#picker').html("Find the work by #{@picked}")
    @$('button').hide()
    $('#guess_again').show()

  generateRandom: =>
    prob = Math.random()
    @index = Math.floor(prob * @collection.models.length)