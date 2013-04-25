class App.Collections.ArtworkImages extends Backbone.Collection

  model: App.Models.ArtworkImage

  additionalImages: ->
    @reject (img) -> img.get 'is_default'

  defaultImage: ->
    @where(is_default: true)[0] or
    @get(@parent?.get 'default_image_id') or
    @first()
