# TODO: Use the mocha javascript API to programmtically run all necessary tests
_ = require 'underscore'
_.mixin require 'underscore.string'
glob = require 'glob'
fs = require 'fs'

testDirs = (dir for dir in fs.readdirSync(__dirname) when not dir.match /\.|helpers|integration|config/)
testFiles = _.flatten (glob.sync(__dirname + '/' + dir + '/**/*_spec.coffee') for dir in testDirs)
require(file) for file in testFiles