#
# Essentially create a stripped down "browser" environment by globally exposing certain parts
# server-side using jsdom, node-jquery, etc.
#

glob = require 'glob'
jsdom = require("jsdom").jsdom
ajaxHelper = require('./ajax_helper')

# Stub a generic DOM and globally expose `window` and `document`
global.document = jsdom "<html><head></head><body></body></html>"
global.window = document.createWindow()

# Globally expose a server-side jQuery and override $.ajax for stubbed responses
require '../../vendor/jquery'
global.$ = global.jQuery = window.$ = window.jQuery
ajaxHelper jQuery

# Globally expose Backbone and set it's DOM libary to our server-side jQuery
global._ = require 'underscore'
global.Backbone = require '../../vendor/backbone'
Backbone.$ = $
Backbone.history = new Backbone.History

global.confirm = -> true
global.prompt = window.prompt = ->
global.alert = window.alert = ->
global.location = { href: '' }
global.navigator = window.navigator
class global.FormData
  append: ->

# Globally expose a faux Jade runtime
global.jade = ((exports) ->
  unless Array.isArray
    Array.isArray = (arr) ->
      "[object Array]" is Object::toString.call(arr)
  unless Object.keys
    Object.keys = (obj) ->
      arr = []
      for key of obj
        arr.push key  if obj.hasOwnProperty(key)
      arr
  exports.attrs = attrs = (obj) ->
    buf = []
    terse = obj.terse
    delete obj.terse

    keys = Object.keys(obj)
    len = keys.length
    if len
      buf.push ""
      i = 0

      while i < len
        key = keys[i]
        val = obj[key]
        if "boolean" is typeof val or null is val
          (if terse then buf.push(key) else buf.push(key + "=\"" + key + "\""))  if val
        else if "class" is key and Array.isArray(val)
          buf.push key + "=\"" + exports.escape(val.join(" ")) + "\""
        else
          buf.push key + "=\"" + exports.escape(val) + "\""
        ++i
    buf.join " "

  exports.escape = escape = (html) ->
    String(html).replace(/&(?!\w+;)/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace /"/g, "&quot;"

  exports.rethrow = rethrow = (err, filename, lineno) ->
    throw err  unless filename
    context = 3
    str = require("fs").readFileSync(filename, "utf8")
    lines = str.split("\n")
    start = Math.max(lineno - context, 0)
    end = Math.min(lines.length, lineno + context)
    context = lines.slice(start, end).map((line, i) ->
      curr = i + start + 1
      (if curr is lineno then "  > " else "    ") + curr + "| " + line
    ).join("\n")
    err.path = filename
    err.message = (filename or "Jade") + ":" + lineno + "\n" + context + "\n\n" + err.message
    throw err

  exports
)({})

global.loadImage = window.loadImage = ->

# Setup & Teardown
afterEach? ->
  $('*').unbind()
  $.ajax.restore?()
  confirm.restore?()
  loadImage.restore?()
  _.defer.restore?()
  _.debounce.restore?()
  _.delay.restore?()
  alert.restore?()
  $('body').each ->
    for attr in @attributes
      $(@).removeAttr attr.name
