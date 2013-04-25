request = require 'request'
AMroutes = require '../../lib/routes'
appConfig = require '../../config/app'

# Block browsers unsupported browsers
app.get '*', (req, res, next) ->
  if (not req.headers['user-agent'].match /Chrome|Safari/) or
     parseInt(/Chrome\/(\d+(\.\d+)*)/.exec(req.headers['user-agent'])?[1]) < 18 or
     parseInt(/Version\/(\d+(\.\d+)*) Safari/.exec(req.headers['user-agent'])?[1]) < 6
    res.render 'error.jade',
      code: 403
      msg: "Sorry, we only support the lastest version of Chrome or Safari on the admin panel."
  else
    next()

AMroutes.requireAccessToken app, appConfig unless app.settings.env is 'test'
AMroutes.loginLogout app, appConfig

# Render Index page
renderIndexPage = (req, res) ->
  userData = null; partnerData= null; priceBuckets= null; errors = []

  render = _.after 2, ->
    if errors.length > 0
      res.render 'error.jade',
        code: 403
        msg:  (err.toString() + '\n' for err in errors).join('') +
            "<a href='/logout'><strong>Log in to another account.</strong></a>"
    else
      res.render 'index',
        userData: JSON.stringify userData
        priceBuckets: JSON.stringify priceBuckets
        gravityUrl: app.gravityUrl
        gravityApiUrl: app.gravityApiUrl
        userAgent: req.headers['user-agent']
        gzipSupport: do ->
          if req.headers['accept-encoding']?
            return req.headers['accept-encoding'].toLowerCase().indexOf('gzip') isnt -1
          else
            return false

  request {
    url: "#{app.gravityApiUrl}/api/v1/me"
    headers: { 'X-ACCESS-TOKEN': req.session.gravityAccessToken }
  }, (err, r, body) ->
    return errors.push err if err
    try
      userData = JSON.parse(body)
    catch err
      errors.push err
    render()

  request {
    url: "#{app.gravityApiUrl}/api/v1/artwork_price_buckets"
    headers: { 'X-ACCESS-TOKEN': req.session.gravityAccessToken }
  }, (err, r, body) ->
    return errors.push err if err
    try
      priceBuckets = JSON.parse body
    catch err
      errors.push err
    render()

app.get '/', renderIndexPage
