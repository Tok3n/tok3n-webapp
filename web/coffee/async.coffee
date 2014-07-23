do ->
  polyfillsUrl = Tok3nDashboard.cdnUrl + '/polyfills/min'

  Modernizr.load([{
  
  # CSS & JS Polyfills
    test: Modernizr.mq
    nope: polyfillsUrl + '/respond.min.js'
  }, {
    test: document.documentElement.classList
    nope: polyfillsUrl + '/classList.min.js'
  }, {
    test: document.querySelector
    nope: polyfillsUrl + '/querySelector.polyfill.js'
  }, {
    test: CSS.supports
    nope: polyfillsUrl + '/CSS.supports.js'
  }, {
    test: CSS.supports('width', 'calc(10px)') or CSS.supports('width', '-webkit-calc(10px)') or CSS.supports('width', '-moz-calc(10px)')
    nope: polyfillsUrl + '/calc.min.js'
  }, {


  # Compatibility layout
    test: CSS.supports('min-height', '-webkit-fill-available') or CSS.supports('min-height', '-moz-available')
    nope: ->
      Tok3nDashboard.compatibilityLayout()
      # Horrible solution for old browsers: keep resizing and setting the height manually in case the content changes. Sorry IE!
      window.setInterval ->
        Tok3nDashboard.resizeContent()
      , 1000
  }, {

  # Typekit
    load: "//use.typekit.net/#{Tok3nDashboard.typekit}.js"
    complete: ->
      try
        Typekit.load()
      return
  }, {
  

  # JS Polyfills
    test: String::contains
    nope: ->
      String::contains = ->
          return String::indexOf.apply( this, arguments ) isnt -1
  }, {
    test: Array::some
    nope: polyfillsUrl + '/array.some.js'
  }, {
    test: Array::filter
    nope: polyfillsUrl + '/array.filter.js'
  }, {
    test: window.MutationObserver
    nope: polyfillsUrl + '/MutationObserver.js'
  }, {
    test: window.Promise
    nope: polyfillsUrl + '/promise-1.0.0.min.js'
  }, {
    test: window.CustomEvent
    nope: polyfillsUrl + '/customevent.js'
  }, {


  # Google Charts
    load: "//www.google.com/jsapi"
    complete: ->
      Tok3nDashboard.Jsapi.isLoaded = new Promise (resolve, reject) ->
        google.load "visualization", "1",
          packages: ["corechart"]
          callback: ->
            resolve()
      ee.emitEvent 'tok3nJsapiPromiseCreated'
      return
  }, {
  
  # Google Analytics
    load: ((if "https:" is location.protocol then "//ssl" else "//www")) + ".google-analytics.com/ga.js"
  }])