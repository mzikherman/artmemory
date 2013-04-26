# Initialize the application after all of the Backbone components have been loaded
$ ->
  console.log 'here'
  App.router = new App.Routers.Index()
  Backbone.history.start pushState: true
  $('#wrong_guess').hide()
  $('#guess_again').hide()
  artworks = new App.Collections.Artworks
  artworks.fetch().then =>
    new App.Views.ArtworksLayout collection: artworks
  