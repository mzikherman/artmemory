require "#{process.cwd()}/test/helpers/spec_helper"

describe 'config production gravity API env', ->

  before ->
    delete require.cache[require.resolve("#{process.cwd()}/config/env.coffee")]
    app.settings.env = 'development'
    process.env.GRAVITY_HOST = ''
    process.env.GRAVITY_PORT = ''
    process.env.GRAVITY_API_HOST = 'custom.artsy.net'
    process.env.GRAVITY_API_PORT = '1234'
    require "#{process.cwd()}/config/env.coffee"

  it 'sets the gravityUrl to localhost:3000', ->
    (app.gravityUrl).should.equal 'http://localhost:3000'

  it "sets the gravityApiHost to custom.artsy.net", ->
    app.gravityApiHost.should.equal 'custom.artsy.net'

  it "sets the gravityApiPort to 1234", ->
    app.gravityApiPort.should.equal '1234'

  it "sets the gravityApiUrl to custom.artsy.net:1234", ->
    app.gravityApiUrl.should.equal 'http://custom.artsy.net:1234'

describe 'config development', ->

  before ->
    delete require.cache[require.resolve("#{process.cwd()}/config/env.coffee")]
    app.settings.env = 'development'
    process.env.PORT = ''
    process.env.GRAVITY_HOST = ''
    process.env.GRAVITY_PORT = ''
    process.env.GRAVITY_API_HOST = ''
    process.env.GRAVITY_API_PORT = ''
    process.env.MASS_HOST = ''
    process.env.MASS_PORT = ''
    require "#{process.cwd()}/config/env.coffee"

  it "sets the root url to localhost:3001", ->
    app.rootUrl.should.equal 'http://localhost:3001'

  it "sets the port to 3001", ->
    process.env.PORT.should.equal '3001'

  describe 'gravity', ->

    it "sets gravity port to 3000", ->
      (app.gravityPort).should.equal 3000

    it "sets gravity root to localhost", ->
      (app.gravityRoot).should.equal 'http://localhost'

    it 'sets the gravityUrl to localhost:3000', ->
      (app.gravityUrl).should.equal 'http://localhost:3000'

    it 'sets the gravityApiUrl to localhost:3000', ->
      (app.gravityApiUrl).should.equal 'http://localhost:3000'

  describe 'mass', ->

    it "sets mass port to 3002", ->
      (app.massPort).should.equal 3002

    it "sets mass root to localhost", ->
      (app.massRoot).should.equal 'http://localhost'

    it 'sets the massUrl to localhost:3002', ->
      (app.massUrl).should.equal 'http://localhost:3002'

describe 'config staging', ->

  before ->
    delete require.cache[require.resolve("#{process.cwd()}/config/env.coffee")]
    app.settings.env = 'staging'
    require "#{process.cwd()}/config/env.coffee"

  it "sets the root url to http://admin.staging.artsy.net", ->
    (app.rootUrl).should.equal 'http://admin.staging.artsy.net'

  describe 'gravity', ->

    it "sets gravity port to 80", ->
      (app.gravityPort).should.equal 80

    it "sets gravity root to staging.artsy.net", ->
      (app.gravityRoot).should.equal 'http://staging.artsy.net'

    it 'sets the gravityUrl to staging.artsy.net', ->
      (app.gravityUrl).should.equal 'http://staging.artsy.net'

    it 'sets the gravityApiUrl to staging.artsy.net', ->
      (app.gravityApiUrl).should.equal 'http://staging.artsy.net'

  describe 'mass', ->

    it "sets mass port to 80", ->
      (app.massPort).should.equal 80

    it "sets mass root to mass.staging.artsy.net", ->
      (app.massRoot).should.equal 'http://mass.staging.artsy.net'

    it 'sets the massUrl to mass.staging.artsy.net', ->
      (app.massUrl).should.equal 'http://mass.staging.artsy.net'

describe 'config production', ->

  before ->
    delete require.cache[require.resolve("#{process.cwd()}/config/env.coffee")]
    app.settings.env = 'production'
    require "#{process.cwd()}/config/env.coffee"

  it "sets the root url to http://admin.artsy.net/", ->
    (app.rootUrl).should.equal 'http://admin.artsy.net'

  describe 'gravity', ->

    it "sets gravity port to 80", ->
      (app.gravityPort).should.equal 80

    it "sets gravity root to artsy.net", ->
      (app.gravityRoot).should.equal 'http://artsy.net'

    it 'sets the gravityUrl to artsy.net', ->
      (app.gravityUrl).should.equal 'http://artsy.net'

    it 'sets the gravityApiUrl to artsyapi.com', ->
      (app.gravityApiUrl).should.equal 'http://artsyapi.com'

  describe 'mass', ->

    it "sets mass port to 80", ->
      (app.massPort).should.equal 80

    it "sets mass root to mass.artsy.net", ->
      (app.massRoot).should.equal 'http://mass.artsy.net'

    it 'sets the massUrl to mass.artsy.net', ->
      (app.massUrl).should.equal 'http://mass.artsy.net'

describe 'config test', ->

  before ->
    delete require.cache[require.resolve("#{process.cwd()}/config/env.coffee")]
    app.settings.env = 'test'
    require "#{process.cwd()}/config/env.coffee"

  it "sets the root url to localhost:5000", ->
    (app.rootUrl).should.equal 'http://localhost:5000'

  it "sets the port to 5000", ->
    (process.env.PORT).should.equal '5000'

  describe 'gravity', ->

    it "sets gravity port to 5001", ->
      (app.gravityPort).should.equal 5001

    it "sets gravity root to localhost", ->
      (app.gravityRoot).should.equal 'http://localhost'

    it 'sets the gravityUrl to localhost:5001', ->
      (app.gravityUrl).should.equal 'http://localhost:5001'

    it 'sets the gravityApiUrl to localhost:5001', ->
      (app.gravityApiUrl).should.equal 'http://localhost:5001'

  describe 'mass', ->

    it "sets mass port to 5002", ->
      (app.massPort).should.equal 5002

    it "sets mass root to localhost", ->
      (app.massRoot).should.equal 'http://localhost'

    it 'sets the massUrl to localhost:5002', ->
      (app.massUrl).should.equal 'http://localhost:5002'
