#
# Expose common modules and spec helpers globally
#

global._ = require 'underscore'
global._.mixin require 'underscore.string'
global.should = require 'should'
global.fabricate = require "./fabricator.coffee"
global.sinon = require 'sinon'
global.fs = require 'fs'
global._jade = require 'jade'
global.xdescribe = ->
global.xit = (title) -> it title
