require "#{process.cwd()}/test/helpers/client_helper.coffee"

describe 'Artwork', ->

  artwork = null

  beforeEach ->
    artwork = new App.Models.Artwork fabricate 'artwork'

  describe '#gravityUrl', ->
    it 'links to gravity', ->
      artwork.gravityUrl().should.include "/artwork/#{artwork.get('id')}"
