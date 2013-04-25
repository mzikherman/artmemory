require "#{process.cwd()}/test/helpers/client_helper.coffee"

describe 'ArtworkImages', ->

  [images, defaultImage, otherImage] = [null, null, null]

  beforeEach ->
    defaultImage = new App.Models.ArtworkImage is_default: true
    otherImage = new App.Models.ArtworkImage is_default: false
    images = new App.Collections.ArtworkImages [defaultImage, otherImage]
