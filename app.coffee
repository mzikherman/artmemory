# 
# Loads up the necessary modules and configuration, then starts the app server
# 

global._ = require 'underscore'
_.str = require('underscore.string')
_.mixin _.str.exports()

global.app = module.exports = require('express')()
require './config/env'
require './config/nap'
require './config/middleware'
require './app/routes'

app.listen process.env.PORT, ->
  console.log "Running in #{app.settings.env} on #{process.env.PORT}"