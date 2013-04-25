# 
# Configure app specific nap settings (https://github.com/craigspaeth/nap)
#

global.nap = require 'nap'

require('./app.coffee').withAssetHash (assetHash) ->
  nap
    mode: if app.settings.env is 'development' then 'development' else 'production'
    assets: require './assets'
    gzip: app.settings.env is 'production'
    cdnUrl: do ->
      switch app.settings.env
        when 'staging' then require('./app.coffee').s3StagingBase + assetHash
        when 'production' then require('./app.coffee').s3ProductionBase + assetHash
        else undefined
