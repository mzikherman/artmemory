describe 'config/app', ->
  gitRev = null

  before (done) ->
    require('child_process').exec "git rev-parse --short HEAD", (error, stdout, stderr) ->
      gitRev = stdout.trim()
      done()

  it 'should define an assetHash based on the current Git revision', (done) ->
    require("#{process.cwd()}/config/app").withAssetHash (assetHash) ->
      assetHash.should.eql gitRev
      done()

  it 'should use ENV["COMMIT_HASH"] if set', (done) ->
    process.env["COMMIT_HASH"] = 'deadbeef'
    require("#{process.cwd()}/config/app").withAssetHash (assetHash) ->
      assetHash.should.eql 'deadbeef'
      process.env["COMMIT_HASH"] = undefined
      done()