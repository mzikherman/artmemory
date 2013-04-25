require "#{process.cwd()}/test/helpers/client_helper.coffee"

sinon = require 'sinon'

describe 'Index router', ->

  router = null

  beforeEach ->
    router = new App.Routers.Index()
