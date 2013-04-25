class App.Models.User extends Backbone.Model

  url: "/api/v1/me"

  _.extend @prototype, Backbone.Relations
  _.extend @prototype, Backbone.TimeStr

  relations: ->
    followed_artists: App.Collections.Artists
    suggested_artists: App.Collections.Artists
    profile: App.Models.Profile
    representative: App.Models.User
    artwork_inquiry_requests: App.Collections.ArtworkInquiryRequests

  initialize: ->
    # @get('followed_artists').url = @url() + '/follow/artists'
    # @get('suggested_artists').url = @url() + '/suggested/artists'
    # @get('suggested_artworks').url = @url() + '/suggested/artworks'
