class App.Collections.Artworks extends Backbone.Collection

  model: App.Models.Artwork

  url: '/api/v1/artworks/interesting'