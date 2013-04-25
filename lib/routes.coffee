#
# Common routes such as authenticating with Gravity and error handlers
#

request = require 'request'
url = require 'url'

@requireAccessToken = (app, appConfig) ->

  # Require an access token before doing anything
  app.get '*', (req, res, next) ->
    ref = req.get('Referrer')
    if req.session?.gravityAccessToken? or req.url.match /logout|api/
      next()
    else if req.query.code? and req.query.response_type is 'code'
      fetchAccessToken req, res, req.query.code, 'gravity', (data) ->
        if data.access_token?
          fetchAccessToken req, res, data.access_token, 'mass', (data) ->
            res.redirect req.path
        else
          res.redirect req.path
    else
      res.redirect "#{app.gravityUrl}/oauth2/authorize" +
                   "?client_id=ec39fac5f9ca9f943fd1" +
                   "&redirect_uri=#{app.rootUrl + req.path}" +
                   "&response_type=code" +
                   "&scope=offline_access"

  # Convenience middleware function to fetch an access token from Gravity or MASS
  # and store it in the session.
  fetchAccessToken = (req, res, code, codename, callback) ->
    console.log 'here'
    oAuthUrl = "#{app[codename + 'Url']}/oauth2/access_token" +
      "?client_id=#{encodeURIComponent('ec39fac5f9ca9f943fd1')}" +
      "&client_secret=#{encodeURIComponent('394888d7566f6521d508a586653c1d52')}" +
      "&code=#{code}" +
      "&grant_type=#{if codename is 'gravity' then 'authorization_code' else 'trust_token'}"
    request oAuthUrl, (err, authRes, body) ->
      if codename is 'gravity' and (err? or authRes.statusCode != 200)
        res.render 'error.jade',
          code: 500
          msg: "There was a problem authenticating with #{codename} \n"
          trace: if err? then err.toString() else body
      else
        try
          data = if typeof body is 'string' then JSON.parse(body) else body
          req.session["#{codename}AccessToken"] = data?.access_token
          callback data
        catch e
          if codename is 'gravity'
            res.render 'error.jade',
              code: 500
              msg: "There was a problem authenticating with #{codename} \n"
              trace: e.toString()
          else
            callback()

@loginLogout = (app, appConfig) ->

  # Log out
  app.get '/logout', (req, res) ->
    req.session = null
    res.redirect "#{app.gravityUrl}/users/sign_out"

@catchAlls = (app) ->

  # Render images locally in development
  app.get '/local/*', (req, res, next) ->
    if app.settings.env is 'development'
      res.redirect app.gravityUrl + req.url
    else
      next()

  # Catch all error handler
  app.use (err, req, res, next) ->
    res.render 'error.jade',
      code: 500
      msg: "There was an internal server error."
      trace: err.stack.toString()

  # 404 page
  app.get '*', (req, res) ->
    res.render 'error.jade',
      code: 404
      msg: "Page not found. <a href='/'>Go home.</a>"
