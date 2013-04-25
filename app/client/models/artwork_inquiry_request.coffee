class App.Models.ArtworkInquiryRequest extends Backbone.Model

  _.extend @prototype, Backbone.TimeStr
  _.extend @prototype, Backbone.Relations

  relations: ->
    'artwork': App.Models.Artwork
    'user': App.Models.User

  urlRoot: "/api/v1/artwork_inquiry_request"

  toJSON: -> _.extend super,
    artwork: @get('artwork')?.get?('id')
    user: @get('user')?.get?('id')
