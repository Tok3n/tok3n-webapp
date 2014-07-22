do ->

  ###
  Main
  ###

  main = () ->
    Tok3nDashboard.Screens.sitewide()
    Tok3nDashboard.slider()
    ee.addListener 'tok3nSlideBeforeAnimation', ->
      initCurrentWindow()
    initCurrentWindow()
    return


  ###
  Selective window behavior
  ###

  destroyActiveWindowJs = ->
    currentWindow = ->
      if Tok3nDashboard.nextTarget isnt undefined
        Tok3nDashboard.nextTarget
      else
        document.querySelector '.tok3n-pt-page-current'
    setTimeout ->
      unless currentWindow().id is 'tok3nDevices'
        false
      unless currentWindow().id is 'tok3nPhonelines'
        false
      unless currentWindow().id is 'tok3nApplications'
        if Tok3nDashboard.masonry?
          Tok3nDashboard.masonry.destroy()
      unless currentWindow().id is 'tok3nIntegrations'
        false
      unless currentWindow().id is 'tok3nBackupCodes'
        false
      unless currentWindow().id is 'tok3nSettings'
        false
    , 250


  toCamelCase = (s) ->
    # http://valschuman.blogspot.mx/2012/08/javascript-camelcase-function.html
    s = s.replace(/([^a-zA-Z0-9_\- ])|^[_0-9]+/g, "").trim().toLowerCase()
    s = s.replace(/([ -]+)([a-zA-Z0-9])/g, (a, b, c) ->
      c.toUpperCase()
    )
    s = s.replace(/([0-9]+)([a-zA-Z])/g, (a, b, c) ->
      b + c.toUpperCase()
    )
    s


  executeIfExists = (arr) ->
    arr.forEach (screen) ->
      if document.querySelector ".tok3n-#{screen}"
        if Tok3nDashboard.Environment.isDevelopment
          console.log toCamelCase(screen)
        if typeof Tok3nDashboard.Screens[toCamelCase(screen)] is 'function'
          Tok3nDashboard.Screens[toCamelCase(screen)]()


  initCurrentWindow = ->
    currentWindow = ->
      if Tok3nDashboard.nextTarget isnt undefined
        Tok3nDashboard.nextTarget
      else
        document.querySelector '.tok3n-pt-page-current'
  
    # Don't render what we won't use
    destroyActiveWindowJs()

    switch currentWindow().id
      # Change this!
      when "tok3nDevices"
        executeIfExists [
          'device-view'
          'device-new-1'
          'device-new-2'
          'device-new-3'
        ]
      when "tok3nPhonelines"
        executeIfExists [
          'phoneline-view-cellphone'
          'phoneline-view-landline'
          'phoneline-new-1'
          'phoneline-new-2'
          'phoneline-new-3'
        ]
      when "tok3nApplications"
        Tok3nDashboard.Screens.applications()
      when "tok3nIntegrations"
        executeIfExists [
          'integration-view'
          'integration-new'
          'integration-edit'
        ]
      when "tok3nBackupCodes"
        false
      when "tok3nSettings"
        Tok3nDashboard.Screens.settings()
      else
        false

  ###
  Vanilla $('document').ready() detection. Execute main() when it is.
  ###

  hasDOMContentLoaded = false
  ready = false
  readyMethod = null

  init = (method) ->
    unless ready
      ready = true
      readyMethod = method
      main()
    return

  document.addEventListener "DOMContentLoaded", (event) ->
    hasDOMContentLoaded = true
    init "DOMContentLoaded"
    return
  document.onreadystatechange = ->
    init "onreadystatechange"
    return
  document.addEventListener "load", (event) ->
    init "load"
    return