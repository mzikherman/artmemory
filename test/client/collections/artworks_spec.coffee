require "#{process.cwd()}/test/helpers/client_helper.coffee"


describe 'App.Collections.Artworks', ->

  artworks = null

  beforeEach ->
    artworks = new App.Collections.Artworks [
      fabricate 'artwork'
      fabricate 'artwork'
      fabricate 'artwork'
    ]
