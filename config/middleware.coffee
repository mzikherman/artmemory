#
# Setup Connect/Express middleware including custom API proxy middleware using nodejitsu
# http-proxy (https://github.com/nodejitsu/node-http-proxy) to proxy any requests sent to the app
# server from /api/*
#

express = require 'express'
httpProxy = require 'http-proxy'
routingProxy = new httpProxy.RoutingProxy()
request = require 'request'

apiProxy = (req, res, next) ->
  host = app.gravityApiHost
  port = app.gravityApiPort
  if req.url.match /\/api\/.*/
    if req.url.match(/// /api/v1/user/.*/access_control ///) and req.method is 'POST'
      params = ("#{k}=#{v}" for k, v of req.query).join('&')
      request {
        url: "#{app.massUrl}#{req.path}?#{params}" 
        headers: { 'X-ACCESS-TOKEN': req.session.MASS_ACCESS_TOKEN }
        method: 'POST'
      }, (err) ->
        console.warn("FAILED TO SYNC ACL WITH MASS", err) if err
    if req.originalMethod in ['POST', 'PUT', 'DELETE'] and not req.headers['content-length']?
      req.headers['content-length'] = 0
    req.headers.host = host
    buffer = httpProxy.buffer(req)
    req.headers['X-ACCESS-TOKEN'] = req.session.gravityAccessToken
    routingProxy.proxyRequest req, res,
      host: host
      port: port
      buffer: buffer
  else
    next()

app.configure ->
  @set 'views', 'app/templates'
  @set 'view engine', 'jade'
  @set 'view options', { layout: false, pretty: true }
  @use nap.middleware
  @use express.methodOverride()
  @use express.cookieParser()
  @use express.cookieSession secret: "bitty"
  @use apiProxy
  @use express.bodyParser()
  @use express.static 'public'
  @use @router
