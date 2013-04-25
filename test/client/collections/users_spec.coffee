require "#{process.cwd()}/test/helpers/client_helper.coffee"

describe 'App.Collections.Users', ->

  beforeEach ->
    @users = new App.Collections.Users [
      fabricate 'user', { name: 'Bobby B' }
      fabricate 'user'
      fabricate 'user'
    ]
