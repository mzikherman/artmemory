#
# This is a node server to fake responses from Gravity for things such as authorization, API proxy
# testing, and server to server http requests. If you want to stub ajax responses it's best to
# add that to /test/helpers/ajax_helper.coffee
#

fabricate = require "#{process.cwd()}/test/helpers/fabricator.coffee"
express = require 'express'
global.gravityServer = server = module.exports = express()

server.configure ->
  @use express.methodOverride()
  @use express.bodyParser()
  @use express.cookieParser()
  @use @router
  @use express.errorHandler
    dumpExceptions: true
    showStack: true


# Allow for stubbing the next response that matches a regex
stubbedNextRes = null
server.stubNextRes = (regex, data) ->
  stubbedNextRes = { regex: regex, data: data }
server.get '*', (req, res, next) ->
  if stubbedNextRes? and req.url.match stubbedNextRes.regex
    res.send(stubbedNextRes.data)
    delete server.stubbedNextRes
  else
    next()

#
# Routes
#

# Log out
server.get "/users/sign_out", (req, res) -> null

# Authorize
server.get "/oauth2/authorize", (req, res) ->
  res.setHeader "Set-Cookie", "_gravity_session=foo"
  res.redirect req.query.redirect_uri

# Access Token
server.get "/oauth2/access_token", (req, res) ->
  res.end JSON.stringify
    access_token: 'fake_access_token'
    refresh_token: 'fake_refresh_token'
    expires_in: '2012-01-13T00:00:00 TZ'

# Price buckets
server.get "/api/v1/artwork_price_buckets", (req, res) ->
  res.send {"GBP":[[null,1000],[1000,2500]]}

# Me
server.get "/api/v1/me", (req, res) ->
  res.end JSON.stringify fabricate 'user', type: 'Admin'

# Misc routes that don't actually exist on Gravity but are used to test Artbuyer
skull = fabricate 'artwork'
server.get '/api/v1/artbuyer_misc/test_types', (req, res) ->
  res.end JSON.stringify skull
server.del '/api/v1/artbuyer_misc/test_types', (req, res) ->
  res.end JSON.stringify skull
server.post '/api/v1/artbuyer_misc/test_types', (req, res) ->
  req.on 'data', (chunk) ->
    res.end JSON.stringify _.extend skull, JSON.parse chunk.toString()
server.put '/api/v1/artbuyer_misc/test_types', (req, res) ->
  res.end JSON.stringify(_.extend skull, req.body)
server.all '/api/v1/artbuyer_misc/test_headers', (req, res) ->
  res.end JSON.stringify req.headers
server.get '/api/v1/artbuyer_misc/test_stream', (req, res) ->
  res.write 'foo'
  setTimeout (-> res.write 'bar'), 100
  setTimeout (-> res.end()), 200
server.get '/api/v1/artbuyer_misc/test_query', (req, res, next) ->
  if req.query.term.match /pic/i
    res.end JSON.stringify(
      [{"id":"pablo-picasso","name":"Pablo Picasso","years":"1881-1973","value":"Pablo Picasso"}]
    )
server.post '/api/v1/user/:id/access_control', (req, res) ->
  res.end JSON.stringify fabricate 'access_control'

# Catch anything else
server.all '*', (req, res, next) ->
  console.log "404: #{req.method} '#{req.url}' doesn't exist on fake Gravity server."
  next()

server.listen 5001, ->
  console.log "Fake gravity server running in #{app.settings.env} on 5001"
