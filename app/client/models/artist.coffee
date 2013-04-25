class App.Models.Artist extends Backbone.Model

  _.extend @prototype, Backbone.Relations

  relations: ->
    artworks: App.Collections.Artworks

  urlRoot: "/api/v1/artist/"

  fetchArtworks: (options) ->
    @get('artworks').url = "/api/v1/artist/#{@get('id')}/artworks"
    @get('artworks').fetch options

  fetchAllArtworks: (callback) ->
    App.getChunkedUntilEnd
      url: "#{@url()}/artworks/all"
      size: 100
      end: (artworks) =>
        @get('artworks').reset artworks
        callback? arguments...

  sortName: ->
    sortName = @get('name')
    if @get('last')?
      sortName = @get('last')
    if @get('first')?
      sortName = "#{sortName} #{@get('first')}"
    sortName

  imageUrl: (version = 'square') ->
    @get('image_url')?.replace(':version', version)
