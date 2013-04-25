# Initialize the application after all of the Backbone components have been loaded
$ ->
  App.currentUser = new App.Models.User(USER)
  App.currentUser.url = '/api/v1/me'
  App.router = new App.Routers.Index()
  App.header = new App.Views.SharedHeader()
  Backbone.history.start pushState: true
  App.router.navigate 'stats', trigger: true if window.location.pathname is '/'

  # All local links should use the router to navigate, pushState FTW
  $('a:not(.refresh)').live 'click', ->
    return unless $(@).attr('href')?.match /^\/|\?/
    if $(@).attr('href')?.match /^\?/
      App.router.navigate window.location.pathname + $(@).attr('href'), trigger: true
    else
      App.router.navigate $(@).attr('href').replace(/^\/|\/$/g, ''), trigger: true
    $(window).scrollTop 0
    false
