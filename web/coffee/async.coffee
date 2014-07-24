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
    test: Modernizr.csscalc
    nope: polyfillsUrl + '/calc.min.js'
  }, {


  # Compatibility layout
    test: Modernizr.extrinsicsizing
    nope: Tok3nDashboard.cdnUrl + '/compatibility.js'
    callback: ->
      if Tok3nDashboard.compatibilityLayout
        Tok3nDashboard.compatibilityLayout()
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
  }])


  # Load external libs, after DOMContenLoaded (on main)
  lastLoader = ->
    Modernizr.load([{
    # Typekit
      load: "//use.typekit.net/#{Tok3nDashboard.typekit}.js"
      complete: ->
        try
          Typekit.load()
        return
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

  Tok3nDashboard.lastLoader = lastLoader