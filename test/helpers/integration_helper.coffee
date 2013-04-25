# 
# Helper to set up integration tests
# 

require './spec_helper'
zombie = require 'zombie'
exec = require('child_process').exec

# Set up zombie browser & apply the ajax_helper
global.browser = new zombie.Browser
  waitFor: if process.env.CI_ENV is 'true' then 1000 else 200
  runScripts: true
  debug: process.env.CI_ENV is 'true'
  site: "http://localhost:5000/"

# Every time a browser loads jQuery override it.
browser.on 'loaded', ->
  browser.wait (-> browser.window.jQuery?), ->
    require('./ajax_helper') browser.window.$

# Log any javascript errors
afterEach ->
  console.log browser.error.stack if browser.error?
  
# Compile assets before running any integration specs
before (done) ->
  exec 'cake assets:fast', (err, stdout, stderr) ->
    console.log stdout
    done()