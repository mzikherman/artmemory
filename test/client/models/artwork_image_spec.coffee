require "#{process.cwd()}/test/helpers/client_helper.coffee"

describe 'ArtworkImage', ->

  image = null

  beforeEach ->
    image = new App.Models.ArtworkImage
      best_height: 100
      best_width: 200
      id: 'foobar'
      image_filename: 'foo.jpg'
      image_url: 'http://stagic.artsy.net/foo/bar/:version.jpg'
      image_versions: ['medium', 'small', 'large']
      is_default: true

  describe 'imageUrl', ->

    it 'returns the image url given a size', ->
      image.imageUrl('small').should.equal 'http://stagic.artsy.net/foo/bar/small.jpg'

    it 'will return an empty string if that version doesnt exist', ->
      image.imageUrl('garbage').should.equal ''
