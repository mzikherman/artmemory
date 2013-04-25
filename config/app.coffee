# App specific configuration

# Artsy API client ID & Secret
@clientId = process.env['ARTSY_CLIENT_ID']
@clientSecret = process.env['ARTSY_CLIENT_SECRET']

# Production & Staging Urls
@productionUrl = 'http://artmemory.herokuapp.com'

# Express.js session secret
@sessionSecret = process.env['EXPRESS_SECRET']

@withAssetHash = (callback) ->
  if process.env['COMMIT_HASH']
    callback(process.env['COMMIT_HASH'])
  else
    require('child_process').exec "git rev-parse --short HEAD", (error, stdout, stderr) ->
      callback(stdout.trim())
