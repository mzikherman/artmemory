require "#{process.cwd()}/test/helpers/client_helper.coffee"

describe 'App.Collections.Artists', ->

  beforeEach ->
    @artists = new App.Collections.Artists [
      fabricate 'artist'
      fabricate 'artist'
      fabricate 'artist'
    ]
