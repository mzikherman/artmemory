glob = require 'glob'
require "#{process.cwd()}/test/helpers/common.coffee"
require "#{process.cwd()}/test/helpers/client_app.coffee"

# Load in App
global.MASS_URL = 'http://mass.test.artsy.net'
global.GRAVITY_URL = 'http://test.artsy.net'
global.MASS_ACCESS_TOKEN = 'mass_token'
require "#{process.cwd()}/app/client/app.coffee"
global.App = window.App

# This would be the best approach for handling our expectation of an ET local time,
# but see https://github.com/joyent/node/issues/3286 ...
#process.env.TZ = 'America/New_York'

# Generic stubs & vendor dependencies
App.router = { on: (->), off: (->), navigate: (->) }

# Require all of our app's templates
assets = require "#{process.cwd()}/config/assets.coffee"
nap = require 'nap'
nap
  publicDir: '/'
  mode: 'develoment'
  assets: assets
eval nap.generateJSTs 'templates'

# Require all the files that attach to `App`
backboneFiles = [
  '/app/client/lib/**/*.coffee'
  '/app/client/models/**/*.coffee'
  '/app/client/collections/**/*.coffee'
  '/app/client/views/**/*.coffee'
  '/app/client/routers/**/*.coffee'
  '/app/client/setup.coffee'
]
for file in backboneFiles
  require(f) for f in glob.sync(process.cwd() + file)

# Setup & Teardown
afterEach? ->
  App.router.navigate.restore?()
