_ = require 'underscore'

rand4 = -> (((1+Math.random())*0x10000)|0).toString(16).substring(1)
uuid = -> "-#{rand4()}#{rand4()}-#{rand4()}-#{rand4()}-#{rand4()}-#{rand4()}#{rand4()}#{rand4()}"

# A simple javascript object fabricator.
#
# @param {String} type Pass it a type like 'artwork' and it'll return the defaults
# @param {Object} extObj Extend the object with an optional extra object
# @return {Object} The final fabricated object

module.exports = fabricate = (type, extObj = {}) ->
  _.extend switch type

    when 'artwork'
      id: 'skull' + uuid()
      title: 'Skull'
      artist:
        id: 'andy-warhol'
        name: "Andy Warhol"
      images: [
        fabricate 'artwork_image'
        fabricate 'artwork_image', is_default: true
      ]
      edition_sets: [
        fabricate 'edition_set'
      ]
      flags: [
        fabricate 'flag'
      ]
      partner: fabricate 'partner'
      category: 'Painting'
      series: 'The coolest series'
      signature: 'Signed by picasso'
      additional_information: 'Urinated on in 2007'
      exhibition_history: 'MOMA, LACMA, and CAC'
      provenance: 'Pwned by the big LG'
      literature: 'Featured in Wired'
      dimensions:
        in: '10 x 20 x 30in'
        cm: '100 x 200 x 40cm'
      metric: 'in'
      display: 'Skull by Andy Warhol'
      collecting_institution: 'MOMA'
      image_rights: 'Sourced from ARS'
      date: '1999'
      medium: 'Watercolor on Paper'
      can_share_image: false
      published: true
      private: false
      tags: []
      genome: fabricate 'genome'

    when 'artwork_image'
      aspect_ratio: 2
      id: uuid()
      image_filename: "original.jpg"
      image_url: "/local/additional_images/4e7cb83e1c80dd00010038e2/1/:version.jpg"
      image_versions: ['small', 'square', 'medium', 'large', 'larger', 'best', 'normalized']
      is_default: false
      max_tiled_height: 585
      max_tiled_width: 1000
      original_height: 585
      original_width: 1000
      tile_base_url: "/local/additional_images/4e7cb83e1c80dd00010038e2/1/dztiles-512-0"
      tile_format: "jpg"
      tile_overlap: 0
      tile_size: 512

    when 'edition_set'
      id: '34f4wawe' + uuid()
      editions: '1,2,3 of 10'
      dimensions:
        in: '10 x 20 x 30in'
        cm: '100 x 200 x 40cm'
      metric: 'in'

    when 'partner'
      id: 'gagosian' + uuid()
      name: 'Gagosian Gallery'
      admin: fabricate 'user'

    when 'artist'
      id: 'pablo-picasso' + uuid()
      name: 'Pablo Picasso'
      blurb: 'This is Pablo Picasso'
      artworks_count: 2
      image_url: '/foo/bar/:version'
      years: '1900-2000'

    when 'user'
      id: 'foobar' + uuid()
      name: 'Craig Spaeth'
      website: null
      email: 'craigspaeth@gmail.com'
      type: 'Admin'
      lab_features: []
      profession: 'engineer'
      address: '401 Broadway'
      collector_level: '5'
      likely_to_purchase: 0
      get: (attr) -> return @[attr]
      set: (attrs) -> _.extend @, attrs

    when 'profile'
      id: 'user_profile'

    when 'profile_icon'
      id: uuid()
      image_filename: "original.jpg"
      image_url: "/local/profile_icons/id/:version.jpg"
      versions: ['square', 'circle']
      profileId: 'user_profile'

    when 'artwork_inquiry_request'
      artwork: fabricate 'artwork'
      id: 'foobaz' + uuid()
      created_at: '2011-11-25T01:10:56-05:00'
      message: 'Oh Hai! I <3 this artwork!'
      phone: '555-555-5555'
      user: fabricate 'user'
      statuses: [
        fabricate 'status'
        fabricate 'status'
      ]
      flags: [
        fabricate 'flag'
      ]

  , extObj
