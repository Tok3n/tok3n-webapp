do ->

  ####################################################
  # Main
  ####################################################

  main = () ->
    sitewide()
    Tok3nDashboard.slider()
    ee.addListener 'tok3nSlideBeforeAnimation', ->
      initCurrentWindow()
    return

  ####################################################
  # Sitewide
  ####################################################

  sitewide = ->
    # Sidebar show/hide
    ((el) ->
      if el
        document.querySelector('#collapseSidebarButton').addEventListener('click', () ->
          el.classList.toggle 'collapsed'
        , false)
        
        menuItems = querySelectorAll('.tok3n-menu-item')
        menuItems.forEach (item) ->
          item.addEventListener 'click', ->
            if window.matchMedia("(max-width: 768px)").matches
              el.classList.toggle 'collapsed'
          , false
        WidthChange = (mq) ->
          if mq.matches
            # Desktop size
            if el.classList.contains 'collapsed'
              el.classList.remove 'collapsed'
          else
            # Mobile size
            unless el.classList.contains 'collapsed'
              el.classList.add 'collapsed'
          return
        if matchMedia
          mq = window.matchMedia("(min-width: 769px)")
          mq.addListener WidthChange
          WidthChange mq
    )(document.querySelector '#tok3nSidebarMenu')

    # Dropdown lists
    ((arr) ->
      if arr
        for el in arr
          el.addEventListener('click', () ->
            for child in el.children
              if child.classList.contains 'dropdown-menu'
                child.classList.toggle 'dropdown-show'
          , false)
    )(document.querySelectorAll '.dropdown')

  ####################################################
  # Selective window behavior
  ####################################################

  destroyActiveWindowJs = ->
    currentWindow = Tok3nDashboard.nextTarget
    setTimeout ->
      unless currentWindow.id is 'tok3nDevices'
        false
      
      else unless currentWindow.id is 'tok3nPhonelines'
        false
      
      else unless currentWindow.id is 'tok3nApplications'
        if Tok3nDashboard.masonry
          Tok3nDashboard.masonry.destroy()
      
      else unless currentWindow.id is 'tok3nIntegrations'
        false
      
      else unless currentWindow.id is 'tok3nBackupCodes'
        false
      
      else unless currentWindow.id is 'tok3nBackupSettings'
        false
    , 250


  camelCaseSwitcher = (arr, func) ->
    arr.forEach (screen) ->
      screenClass = ".tok3n-" + screen.replace(/([a-z])([A-Z])/g, '$1-$2').replace(/([a-zA-Z]+)([0-9]+)/g, '$1-$2').toLowerCase();
      func(screen)

  initCurrentWindow = ->
    currentWindow = Tok3nDashboard.nextTarget
  
    # Don't render what we won't use
    destroyActiveWindowJs()

    switch currentWindow.id
      # Change this!
      when "tok3n-signup"
        signupScreens = ['signupEnable', 'signupCreate1', 'signupCreate2', 'signupDevice1', 'signupDevice2', 'signupPhoneline1', 'signupPhoneline2']
        camelCaseSwitcher signupScreens, (currentWindow) ->
          switch currentWindow
            when 'signupEnable'
              false
            when 'signupCreate1'
              false
            when 'signupCreate2'
              false
            when 'signupPhoneline1'
              false
            when 'signupPhoneline2'
              false
            else
              false

      when "tok3ndDevices"
        false
      when "tok3nPhonelines"
        false
      when "tok3nApplications"
        authorizedApps()
      when "tok3nIntegrations"
        false
      when "tok3nBackupCodes"
        false
      when "tok3nSettings"
        false
      else
        false

  ####################################################
  # Authorized apps
  ####################################################

  authorizedApps = () ->
    # Masonry apps container
    ((el) ->
      if el
         Tok3nDashboard.masonry = new Masonry(el, {
          itemSelector: '.card'
          gutter: '.grid-gutter'
        })
    )(document.querySelector '.tok3n-cards-container')

  ####################################################
  # Vanilla $('document').ready() detection. Execute main() when it is.
  ####################################################

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