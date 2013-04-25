#
# A helper to make mocking & checking ajax easier:
# Wraps jquery's $.ajax to stub API responses.
# Sets the last ajax request as a global jqLastAjaxRequest.
#

fabricate = require './fabricator'
_ = require 'underscore'

afterEach -> delete jqLastAjaxRequest if jqLastAjaxRequest?

module.exports = (jQuery) ->

  # Allow for the next ajax response to be temporarily changed
  _stubbedNextJqAjaxUrl = null
  _stubbedNextJqAjaxRes = null
  global.stubNextJqAjaxResponse = (url, res) ->
    _stubbedNextJqAjaxUrl = url
    _stubbedNextJqAjaxRes = res

  # Wrap jQuery's ajax to catch any calls and stub responses.
  # If it doesn't match anything pass it on to the normal jQuery.ajax
  jQuery.ajax = (settings) ->

    global.jqLastAjaxRequest = settings

    reqUrl = settings.url or settings
    dfd = jQuery.Deferred()

    # Create a helper function to clean up this DSL
    matched = false
    matches = (regexStr, responseCb, stubStatus='success', stubHeaders={ 'x-total-count': 10 }) ->
      return if matched
      if reqUrl.match new RegExp regexStr
        matched = true
        res = responseCb()
        global.jqLastAjaxRes = res
        xhrStub = { getResponseHeader: (key) -> stubHeaders[key] }
        settings.success? res, stubStatus, xhrStub
        dfd.resolve res, stubStatus, xhrStub

    if (_.isString(_stubbedNextJqAjaxUrl) and _stubbedNextJqAjaxUrl is reqUrl) or
       (_.isRegExp(_stubbedNextJqAjaxUrl) and reqUrl.match _stubbedNextJqAjaxUrl)
      matches = ->
      settings.success? _stubbedNextJqAjaxRes
      dfd.resolve _stubbedNextJqAjaxRes
      _stubbedNextJqAjaxRes = null
      _stubbedNextJqAjaxUrl = null
      matched = true

    #
    # ROUTES
    #

    # Me
    matches '^/api/v1/me$', ->
      id: '1337'
      name: 'Brennan'
      email: 'brennan@artsymail.com'

    matches '/api/v1/match', ->
      if settings.data?.term.match /pic/i
        [
          {
            model: 'artist'
            id: 'pablo-picasso'
            display: 'Pablo Picasso'
            label: 'Artist'
            score: 'excellent'
          }
          {
            "model":"artwork"
            "id":"pablo-picasso-pain"
            "display":"Pain (10) by Pablo Picasso"
            "label"
            "Artwork","score":"excellent"
          }
        ]
      else if settings.data?.term.match /warh/i
        [
          {
            model: 'artist'
            id: 'andy-warhol'
            display: 'Andy Warhol'
            label: 'Artist'
            score: 'excellent'
          }
        ]
      else if settings.data?.term.match /gag/i
        [
          {
            "model": "partner"
            "id":"gagosian-gallery"
            "display":"Gagosian Gallery"
            "label":"Partner"
            "score":"excellent"
          }
        ]
      else
        [
          {
            "model": "noop"
            "id":"noop"
            "display":"Matched Nothing"
            "label":"Something"
            "score":"excellent"
          }
        ]


    # Artwork Inquiry Requests
    matches '/api/v1/artwork_inquiry_requests', -> [
      fabricate 'artwork_inquiry_request'
      fabricate 'artwork_inquiry_request'
      fabricate 'artwork_inquiry_request'
    ]
    matches '/api/v1/partner/.*/artwork_inquiry_requests', -> [
      fabricate 'artwork_inquiry_request'
      fabricate 'artwork_inquiry_request'
      fabricate 'artwork_inquiry_request'
    ]
    matches '/api/v1/artist/.*/artwork_inquiry_requests', -> [
      fabricate 'artwork_inquiry_request'
      fabricate 'artwork_inquiry_request'
      fabricate 'artwork_inquiry_request'
    ]
    matches '/api/v1/artwork/.*/artwork_inquiry_requests', -> [
      fabricate 'artwork_inquiry_request'
      fabricate 'artwork_inquiry_request'
      fabricate 'artwork_inquiry_request'
    ]
    matches '/api/v1/user/.*/artwork_inquiry_requests', -> [
      fabricate 'artwork_inquiry_request'
      fabricate 'artwork_inquiry_request'
      fabricate 'artwork_inquiry_request'
    ]
    matches '/api/v1/artwork_inquiry_request', -> fabricate 'artwork_inquiry_request'
    matches '/api/v1/representative/craig/artwork_inquiry_requests', -> [
      fabricate 'artwork_inquiry_request'
      fabricate 'artwork_inquiry_request'
    ]
    matches '^/api/v1/partner/.*', -> fabricate('partner')

    # Artist
    matches '/api/v1/artist/.*/artworks', -> [
      fabricate 'artwork', title: 'La Vie', artist: {id: 'pablo-picasso', name: 'Pablo Picasso'}
      fabricate 'artwork', title: 'Nu debout', artist: {id: 'pablo-picasso', name: 'Pablo Picasso'}
    ]
    matches '/api/v1/artist/artworks.*', -> [
      fabricate 'artwork', title: 'La Vie', artist: {id: 'pablo-picasso', name: 'Pablo Picasso'}
    ]
    matches '/api/v1/artist/.*', -> fabricate 'artist'
    matches '/api/v1/artists/sample', -> [fabricate('artist'), fabricate('artist')]

    # Artwork
    matches '/api/v1/artwork/.*', ->
      if settings.type.match /POST|PUT/ and settings.data?
        data = JSON.parse settings.data
        delete data.artist
        delete data.partner
      fabricate 'artwork', data
    matches '/api/v1/artwork', ->
      fabricate 'artwork'

    # Catch any routes that don't exist and let the normal jQuery function handle them
    if not matched
      console.log """
        Route '#{reqUrl}' is not stubbed, consider adding to /test/helpers/ajax_helper.coffee
      """
    return dfd
