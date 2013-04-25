require "#{process.cwd()}/test/helpers/spec_helper"
request = require 'request'

describe 'requesting from /api/', ->

  it "Renders a response from the Artsy API for GET calls", (done) ->
    request 'http://localhost:5000/api/v1/artbuyer_misc/test_types', (err, res, body) ->
      (JSON.parse(body).id).should.include 'skull'
      done()

  it "Renders a response from the Artsy API for DELETE calls", (done) ->
    request.del 'http://localhost:5000/api/v1/artbuyer_misc/test_types', (err, res, body) ->
      (JSON.parse(body).id).should.include 'skull'
      done()

  it "Handles lack of body.length for DELETE like a boss", (done) ->
    request.del 'http://localhost:5000/api/v1/artbuyer_misc/test_types', (err, res, body) ->
      (JSON.parse(body).id).should.include 'skull'
      done()

  it "passes content-length for DELETE calls without the header", (done) ->
    request.del 'http://localhost:5000/api/v1/artbuyer_misc/test_headers', (err, res, body) ->
      (JSON.parse(body)['content-length']?).should.be.ok
      done()

  it "Puts the body params in POST calls", (done) ->
    request.post {
      url: 'http://localhost:5000/api/v1/artbuyer_misc/test_types'
      body: JSON.stringify { title: 'foo' }
    }, (err, res, body) ->
      (JSON.parse(body).title).should.equal 'foo'
      done()

  it "Puts the body params in PUT calls", (done) ->
    request.put {
      url: 'http://localhost:5000/api/v1/artbuyer_misc/test_types'
      body: JSON.stringify(title: 'foo')
    }, (err, res, body) ->
      (JSON.parse(body).title).should.equal 'foo'
      done()

  it "Works with query params such as match/artists?term =", (done) ->
    request 'http://localhost:5000/api/v1/artbuyer_misc/test_query?term=pic', (err, res, body) ->
      (JSON.parse(body)[0].name).should.equal 'Pablo Picasso'
      done()

  it 'deals with streaming response for large data', (done) ->
    request 'http://localhost:5000/api/v1/artbuyer_misc/test_stream', (err, res, body) ->
      body.should.equal 'foobar'
      done()

  xit 'syncs mass access controls', (done) ->
    request.post 'http://localhost:5000/api/v1/user/foo/access_control?model=partner&id=bar', (err, res, body) ->
      stub.args[0][0].should.equal 'http://localhost:5002/api/v1/user/foo/access_control?model=partner&id=bar'
      done()
      stub.restore()
    stub = sinon.stub request, 'post'
