class App.Models.Artwork extends Backbone.Model

  _.extend @prototype, Backbone.Relations
  _.extend @prototype, Backbone.TimeStr

  urlRoot: "/api/v1/artwork"

  defaults:
    metric: 'in'
    images: []
    edition_sets: []

  relations: ->
    artist: App.Models.Artist
    images: App.Collections.ArtworkImages

  defaultAvailability: ->
    if @partner?.get('type') is 'Gallery' then 'for sale' else 'not for sale'

  defaultImage: ->
    @get('images')?.defaultImage()

  defaultImageUrl: (size = 'small', usePlaceholder = false) ->
    @defaultImage()?.imageUrl(size, usePlaceholder)

  artistName: ->
    @get('artist')?.get('name')

  gravityUrl: ->
    "#{GRAVITY_URL}/artwork/#{@get('id')}"
