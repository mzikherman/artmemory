#
# Generic spec helper for all tests
#

require "#{process.cwd()}/test/helpers/common.coffee"

process.env.NODE_ENV = 'test'
require "#{process.cwd()}/test/helpers/gravity_server.coffee"
require "#{process.cwd()}/app.coffee"
process.on 'exit', ->
  try
    app?.close()
    gravityServer?.close()
