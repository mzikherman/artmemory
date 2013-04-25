class App.Collections.Artists extends Backbone.Collection

  model: App.Models.Artist

  shortJSONConfig: [
    [ "Name",  (a) -> a.get('name') ]
    [ "Image URL",  (a) -> a.get('image_url') ]
    [ "Published Artworks Count", (a) -> a.get('published_artworks_count') ]
    [ "Years", (a) -> a.get('years') ]
  ]
