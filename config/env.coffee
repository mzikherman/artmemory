#
# Configure environment specific variables & middleware
#

express = require 'express'
path = require 'path'

switch app.settings.env

  when 'development'
    app.port = process.env.PORT || 3001
    app.rootUrl = "http://#{process.env.HOST || 'localhost'}:#{app.port}"
    app.gravityHost = process.env.GRAVITY_HOST || 'localhost'
    app.gravityPort = process.env.GRAVITY_PORT || 3000
    app.gravityApiHost = process.env.GRAVITY_API_HOST || 'localhost'
    app.gravityApiPort = process.env.GRAVITY_API_PORT || 3000
    app.massHost = process.env.MASS_HOST || 'localhost'
    app.massPort = process.env.MASS_PORT || 3002
    process.env.PORT = app.port
    app.use express.errorHandler dumpExceptions: true, showStack: true

  when 'test'
    app.port = 5000
    app.rootUrl = "http://localhost:#{app.port}"
    app.gravityHost = 'localhost'
    app.gravityPort = 5001
    app.gravityApiHost = 'localhost'
    app.gravityApiPort = 5001
    app.massHost = 'localhost'
    app.massPort = 5002
    process.env.PORT = app.port
    app.use express.errorHandler dumpExceptions: true, showStack: true

  when 'staging'
    app.rootUrl = if process.env.HOST then "http://#{process.env.HOST}" else require('./app.coffee').stagingUrl
    app.gravityHost = process.env.GRAVITY_HOST || 'staging.artsy.net'
    app.gravityPort = process.env.GRAVITY_PORT || 80
    app.gravityApiHost = process.env.GRAVITY_API_HOST || 'staging.artsy.net'
    app.gravityApiPort = process.env.GRAVITY_API_PORT || 80
    app.massHost = process.env.MASS_HOST || 'mass.staging.artsy.net'
    app.massPort = process.env.MASS_PORT || 80
    app.use express.errorHandler()

  when 'production'
    app.rootUrl = if process.env.HOST then "http://#{process.env.HOST}" else require('./app.coffee').productionUrl
    app.gravityHost = process.env.GRAVITY_HOST || 'artsy.net'
    app.gravityPort = process.env.GRAVITY_PORT || 80
    app.gravityApiHost = process.env.GRAVITY_API_HOST || 'artsyapi.com'
    app.gravityApiPort = process.env.GRAVITY_API_PORT || 80
    app.massHost = process.env.MASS_HOST || 'mass.artsy.net'
    app.massPort = process.env.MASS_PORT || 80
    app.use express.errorHandler()

app.gravityRoot = 'http://' + app.gravityHost
app.gravityUrl = app.gravityRoot + (if app.gravityPort is 80 then '' else ":#{app.gravityPort}")

app.gravityApiRoot = 'http://' + app.gravityApiHost
app.gravityApiUrl = app.gravityApiRoot + (if app.gravityApiPort is 80 then '' else ":#{app.gravityApiPort}")

app.massRoot = 'http://' + app.massHost
app.massUrl = app.massRoot + (if app.massPort is 80 then '' else ":#{app.massPort}")
