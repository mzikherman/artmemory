class App.Models.ArtworkImage extends Backbone.Model

  urlRoot: ->
    "#{@collection.parent.url()}/image"

  imageUrl: (size = 'small', usePlaceholder = false) ->
    if @get('dataUrls')
      @get('dataUrls')[size]
    else if @get('image_versions') and size in @get('image_versions')
      @get('image_url')?.replace(':version', size)
    else
      if usePlaceholder then @THUMBNAIL_PLACEHOLDER_URL else ''

  parse: (res) ->
    res.original_height = @get('original_height') if @get('original_height')
    res.original_width = @get('original_width') if @get('original_width')
    res
