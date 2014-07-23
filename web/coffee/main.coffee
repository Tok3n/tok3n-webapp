do ->

  ###
  Main
  ###

  main = () ->
    # Init sidebar, sitewide and slider
    Tok3nDashboard.Screens.sitewide()
    Tok3nDashboard.slider()
    
    # Change current window js on slide
    ee.addListener 'tok3nSlideBeforeAnimation', ->
      initCurrentWindow()
    
    initCurrentWindow()
    
    # React to DOM changes (partial views insertion/removal)
    querySelectorAll('.tok3n-main-content').forEach (el) ->
      observePageChanges el
    
    # Press key "1" to test alerts, "2" to activate alert
    if Tok3nDashboard.Environment.isDevelopment
      window.addEventListener "keyup", ( event ) ->
        if event.keyCode is 49
          querySelectorAll('.tok3n-dashboard-alert').forEach (el) ->
            el.classList.toggle('tok3n-dashboard-alert-hidden')
      window.addEventListener "keyup", ( event ) ->
        if event.keyCode is 50
          querySelectorAll('.tok3n-dashboard-alert').forEach (el) ->
            el.classList.remove('tok3n-dashboard-alert-active')
            setTimeout ->
              el.classList.add('tok3n-dashboard-alert-active')
            , 0
    return


  ###
  Selective window behavior
  ###

  destroyMasonry = ->
    if Tok3nDashboard.masonry
      if Tok3nDashboard.masonry.isResizeBound
        Tok3nDashboard.masonry.destroy()
        if Tok3nDashboard.Environment.isDevelopment
          console.log 'Destroyed masonry.'

  destroyValidatedForms = ->
    if Tok3nDashboard.ValidatedForms.length
      Tok3nDashboard.ValidatedForms.forEach (el) ->
        el.parsley().destroy()
        if Tok3nDashboard.Environment.isDevelopment
          if el.attr 'id'
            console.log "Destroyed Validated form ##{el.attr 'id'}"
          else
            console.log 'Destroyed validated form with no id.'
      Tok3nDashboard.ValidatedForms = []

  destroyActiveWindowJs = ->
    currentWindow = ->
      if Tok3nDashboard.nextTarget isnt undefined
        Tok3nDashboard.nextTarget
      else
        document.querySelector '.tok3n-pt-page-current'
    
    # Page independant, in the future it should destroy forms selectively, in order to do it after the transition
    destroyValidatedForms()

    # This function is problematic, it should use a promise to avoid unintended behavior.
    setTimeout ->
      unless currentWindow().id is 'tok3nDevices'
        false
      unless currentWindow().id is 'tok3nPhonelines'
        false
      unless currentWindow().id is 'tok3nApplications'
        destroyMasonry()
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
          console.log toCamelCase(screen) + " is the current screen"
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
          'devices'
          'device-view'
          'device-new-1'
          'device-new-2'
          'device-new-3'
        ]
      when "tok3nPhonelines"
        executeIfExists [
          'phonelines'
          'phoneline-view-cellphone'
          'phoneline-view-landline'
          'phoneline-new-1'
          'phoneline-new-2'
          'phoneline-new-3'
        ]
      when "tok3nApplications"
        executeIfExists [
          'applications'
        ]
      when "tok3nIntegrations"
        unless Tok3nDashboard.Charts.areLoaded
          Tok3nDashboard.Screens.integrationsCharts()
        executeIfExists [
          'integrations'
          'integration-view'
          'integration-new'
          'integration-edit'
        ]
      when "tok3nBackupCodes"
        executeIfExists [
          'backup-codes'
        ]
      when "tok3nSettings"
        executeIfExists [
          'settings'
        ]
      else
        false


  observePageChanges = (el) ->
    observer = new MutationObserver (mutations) ->
      mutations.forEach (mutation) ->
        if Tok3nDashboard.Environment.isDevelopment
          console.log "Partial screen change detected."
        false
        initCurrentWindow()
    observer.observe el,
      childList: true
      # characterData: true
      # subtree: true


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