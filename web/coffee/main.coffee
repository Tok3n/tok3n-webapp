do ->

  ###
  Main
  ###

  main = () ->
    # Init sidebar, sitewide and slider
    Tok3nDashboard.Screens.sitewide()
    Tok3nDashboard.slider()
    
    # Change current window js on slide and init first time
    ee.addListener 'tok3nSlideBeforeAnimation', ->
      initCurrentWindow()
    initCurrentWindow()
    
    # React to DOM changes (partial views insertion/removal)
    querySelectorAll('.tok3n-main-content').forEach (el) ->
      if Tok3nDashboard.compatibilityLayout
        compatibilityObserver el
      else
        observePageChanges el

    ee.addListener 'tok3nSlideAfterAnimation', ->
      false
    
    # Load google charts, analytics and typekit
    Tok3nDashboard.lastLoader()

    # Testing funcs
    if Tok3nDashboard.Environment.isDevelopment
      testAlerts()
      testFormEvents()


  ###
  Selective window behavior
  ###

  currentWindow = ->
    if Tok3nDashboard.nextTarget isnt undefined
      Tok3nDashboard.nextTarget
    else
      document.querySelector '.tok3n-pt-page-current'
      

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

  toTok3nCssClass = (camel) ->
    "tok3n-" + camel.replace(/([a-z])([A-Z])/g, '$1-$2').replace(/([a-zA-Z]+)([0-9]+)/g, '$1-$2').toLowerCase()


  initIfExists = (arr) ->
    arr.forEach (screen) ->
      currentScreen = document.querySelector ".tok3n-#{screen}"
      if currentScreen
        funcName = toCamelCase(screen)
        if typeof Tok3nDashboard.Screens[funcName] is 'function'
          Tok3nDashboard.CurrentScreens.push(currentScreen)
          devConsoleLog "Inited #{funcName}"
          Tok3nDashboard.Screens[funcName]()


  destroyPrevious = ->
    setTimeout ->
      if Tok3nDashboard.PreviousScreens.length
        Tok3nDashboard.PreviousScreens.forEach (screen) ->
          commonName = undefined
          screenKind = undefined
          # If it's a .tok3n-pt-page
          unless screen.id.indexOf 'tok3n' is -1
            commonName = lowercaseFirstLetter screen.id.replace('tok3n', '')
            screenKind = 'main page'
          # If it's a partial
          else
            commonName = toCamelCase screen.classList[0].replace('tok3n-', '')
            screenKind = 'partial'
          destroyName = 'destroy' + capitaliseFirstLetter commonName
          if typeof Tok3nDashboard.Screens[destroyName] is 'function'
            Tok3nDashboard.Screens[destroyName]()
            devConsoleLog "Destroyed #{screenKind} #{commonName}"
      Tok3nDashboard.PreviousScreens = Tok3nDashboard.CurrentScreens
      Tok3nDashboard.CurrentScreens = []
    , Tok3nDashboard.slidingAnimationDuration


  switchWindow = ->
    switch currentWindow().id
      when "tok3nDevices"
        initIfExists [
          'devices'
          'device-view'
          'device-new-1'
          'device-new-2'
          'device-new-3'
        ]
      when "tok3nPhonelines"
        initIfExists [
          'phonelines'
          'phoneline-view-cellphone'
          'phoneline-view-landline'
          'phoneline-new-1'
          'phoneline-new-2'
          'phoneline-new-3'
        ]
      when "tok3nApplications"
        initIfExists [
          'applications'
        ]
      when "tok3nIntegrations"
        unless Tok3nDashboard.Charts.areLoaded
          Tok3nDashboard.Screens.integrationsCharts()
        initIfExists [
          'integrations'
          'integration-view'
          'integration-new'
          'integration-edit'
        ]
      when "tok3nBackupCodes"
        initIfExists [
          'backup-codes'
        ]
      when "tok3nSettings"
        initIfExists [
          'settings'
        ]
      else
        false

  initCurrentWindow = ->
    # devConsoleLog 'Started initing js.'
    Tok3nDashboard.Screens.initEveryTime()
    switchWindow()
    destroyPrevious()
    Tok3nDashboard.Screens.destroyEveryTime()
    # devConsoleLog 'Finished initing js.'


  observePageChanges = (el) ->
    observer = new MutationObserver (mutations) ->
      mutations.forEach (mutation) ->
        devConsoleLog "Partial screen change detected."
        initCurrentWindow()
    observer.observe el,
      childList: true


  compatibilityObserver = (el) ->
    observer = new MutationObserver (mutations) ->
      mutations.forEach (mutation) ->
        devConsoleLog "Partial screen change detected."
        destroyCurrentIfExists()
        Tok3nDashboard.resizeContent()
    observer.observe el,
      childList: true
      # characterData: true
      subtree: true
      # attributes: true


  ###
  Testing functions
  ###
  
  testAlerts = ->
    # Press key "1" to test alerts, "2" to activate alert
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
  

  testFormEvents = ->
    window.addEventListener 'submitValidatedForm', (evt) ->
      console.log evt
    , false

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