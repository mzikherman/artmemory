#
# Load a our client-side application and attach it to our fake minimal "browser" environment
#

glob = require 'glob'
_jade = require 'jade'
fs = require 'fs'
require './client_env'

# Globally expose `JST` and generate the JST templates for testing views
global.JST = window.JST = {}

global.App = window.App =
  Collections: {}
  Models:
    Behaviors: {}
  Views: {}
  Routers: {}

# Generic stubs
App.router = { on: (->), off: (->), navigate: (->) }

# Setup & Teardown
afterEach ->
  $.xhrMap = {}
