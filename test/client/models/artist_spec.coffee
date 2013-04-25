require "#{process.cwd()}/test/helpers/client_helper.coffee"

describe 'App.Models.Artist', ->

  artist = null

  beforeEach ->
    artist = new App.Models.Artist fabricate 'artist', id: 'ryan-trecartin'
