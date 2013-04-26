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
    'click .item' : 'guess'

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
      
  startGame:(e) =>
    unless @started
      @started = true
      @seconds = 10
      @$timer.html("#{@seconds} seconds left...")
      @window_tick = =>
        @tick()
      setInterval(@window_tick, 1000)

  tick: =>
    @seconds -= 1
    if @seconds <= 0
      clearInterval(@window_tick)
      @$timer.html('Game now beginning')
      @beginGame()
    else
      @$timer.html("#{@seconds} seconds left...")

  beginGuessingGame: =>
    @picked = @collection.models[@generateRandom()].get('artist').name
    @$('#picker').html("Find the work by #{@picked}")

  generateRandom: =>
    prob = Math.random()
    @index = Math.floor(prob * @collection.models.length)