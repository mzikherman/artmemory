fs = require 'fs'
nap = require('nap')
_ = require 'underscore'
knox = require 'knox'
assets = require('./config/assets.coffee')
child_process = require 'child_process'

###
Asset tasks
###

task 'assets', 'Compile, embed, minify, and gzip asset packages', ->
  console.log "Compiling, packaging, embedding, minifying, & gzipping assets..."
  start = new Date().getTime()
  nap
    mode: 'production'
    assets: assets
    gzip: true
  nap.package()
  end = new Date().getTime()
  console.log "Finished in #{end - start}ms!"

task 'assets:fast', 'Compile asset packages but dont embed, minify, or gzip anything', ->
  console.log "Compiling & packaging assets..."
  start = new Date().getTime()
  nap
    mode: 'development'
    assets: assets
    gzip: false
  nap.package()
  end = new Date().getTime()
  console.log "Finished in #{end - start}ms!"

task 'assets:to_staging', 'compile assets to S3 for staging', ->
  spawnSafe "cake assets", ->
    packageToS3 'staging'

task 'assets:to_production', 'compile assets to S3 for production', ->
  spawnSafe "cake assets", ->
    packageToS3 'production'

task 'test', 'run Mocha tests', ->
  spawnSafe "mocha -r should --growl -t 10000 -R list", ->
    spawnSafe "mocha test/config -r should --growl -t 10000 -R list"

task 'deploy:staging', 'compile assets and deploy latest to staging', ->
  spawnSafe "cake assets:to_staging", ->
    deploySafe 'staging'

task 'deploy:production', 'compile assets and deploy latest to production', ->
  spawnSafe "cake assets:to_production", ->
    deploySafe 'production'

deploySafe = (env) ->
  require('./config/app').withAssetHash (assetHash) ->
    app = "artbuyer-#{env}"
    spawnSafe "git push git@heroku.com:#{app}.git master", ->
      spawnSafe "heroku config:add COMMIT_HASH=#{assetHash} --app #{app}"

packageToS3 = (env) ->
  require('./config/app').withAssetHash (assetHash) ->
    opts =
      key: require('./config/app').s3Key
      secret: require('./config/app').s3Secret
      bucket: do ->
        switch env
          when 'production' then require('./config/app').s3ProductionBucket
          when 'staging' then require('./config/app').s3StagingBucket
    client = knox.createClient opts

    packages = for file in fs.readdirSync "public/assets/" when not file.match /^\./
      "public/assets/#{file}"

    for pkg in packages
      headers = {}
      headers['Content-Type'] = if pkg.match /\.css/ then 'text/css' else 'application/javascript'
      headers['Content-Encoding'] = 'gzip' if pkg.match /gz$/
      headers['x-amz-acl'] = 'public-read'
      client.putFile pkg, "/assets/#{assetHash}/#{_.last pkg.split('/')}", headers, _.bind(((err, res) ->
        throw err if err
        console.log "Uploaded #{@} to s3://#{opts.bucket}/#{assetHash}/"
      ), pkg)

spawnWithEnv = (command, env, callback = (->)) ->
  args = command.split(" ")
  newEnv = _.clone process.env
  _.extend newEnv, env

  child = child_process.spawn args[0], _.rest(args),
    customFds: [0, 1, 2]
    env: newEnv
  child.on 'exit', (code) ->
    if code == 0
      callback()
    else
      process.exit(code)

spawnSafe = (command, callback = (->)) ->
  args = command.split(" ")

  child = child_process.spawn args[0], _.rest(args),
    customFds: [0, 1, 2]
  child.on 'exit', (code) ->
    if code == 0
      callback()
    else
      process.exit(code)
