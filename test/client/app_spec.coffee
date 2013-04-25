require "#{process.cwd()}/test/helpers/client_helper.coffee"

describe "App", ->

  it 'namespaces components', ->
    (window.App.Models?).should.be.ok
    (window.App.Collections?).should.be.ok
    (window.App.Views?).should.be.ok
    (window.App.Routers?).should.be.ok

  it 'extends backbone events', ->
    (window.App.bind?).should.be.ok
