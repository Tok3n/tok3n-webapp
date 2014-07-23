do ->
  
  Modernizr.load([{
  
  # CSS & JS Polyfills
    test: Modernizr.mq
    nope: 'https://raw.githubusercontent.com/scottjehl/Respond/master/dest/respond.min.js'
  }, {
    test: document.documentElement.classList
    nope: 'https://raw.githubusercontent.com/eligrey/classList.js/master/classList.min.js'
  }, {
    test: document.querySelector
    nope: 'https://gist.githubusercontent.com/chrisjlee/8960575/raw/53c2a101030437f02fe774f43733673f99a13a0a/querySelector.polyfill.js'
  }, {
    test: CSS.supports
    nope: 'https://raw.githubusercontent.com/termi/CSS.supports/master/__COMPILED/CSS.supports.js'
  }, {
    test: CSS.supports('width', 'calc(10px)') or CSS.supports('width', '-webkit-calc(10px)') or CSS.supports('width', '-moz-calc(10px)')
    nope: 'https://raw.githubusercontent.com/closingtag/calc-polyfill/master/calc.min.js'
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
  
  # JS Polyfills
    test: String::contains
    nope: ->
      String::contains = ->
          return String::indexOf.apply( this, arguments ) isnt -1
  }, {
    test: Array::some
    nope: ->
      Array::some = (fun, thisArg) ->
        "use strict"
        throw new TypeError() if this is undefined or this is null
        t = Object( this )
        len = t.length >>> 0
        throw new TypeError() if typeof fun isnt "function"
        thisArg = if arguments.length >= 2 then arguments[1] else undefined
        i = 0
        while i < len
          return true if i of t and fun.call( thisArg, t[i], i, t )
          i++
        return false
  }, {
    test: Array::filter
    nope: ->
      Array::filter = (fun) ->
        "use strict"
        throw new TypeError()  if this is undefined or this is null
        t = Object(this)
        len = t.length >>> 0
        throw new TypeError()  if typeof fun isnt "function"
        res = []
        thisArg = (if arguments_.length >= 2 then arguments_[1] else undefined)
        i = 0
        while i < len
          if i of t
            val = t[i]
            res.push val  if fun.call(thisArg, val, i, t)
          i++
        res
  }, {
    test: window.MutationObserver
    nope: "https://raw.githubusercontent.com/Polymer/MutationObservers/master/MutationObserver.js"
  }, {
    test: window.Promise
    nope: 'http://s3.amazonaws.com/es6-promises/promise-1.0.0.min.js'
  }, {
    test: window.CustomEvent
    nope: ->
      CustomEvent = (event, params) ->
        params = params or
          bubbles: false
          cancelable: false
          detail: undefined

        evt = document.createEvent("CustomEvent")
        evt.initCustomEvent event, params.bubbles, params.cancelable, params.detail
        evt
      CustomEvent:: = window.Event::
      window.CustomEvent = CustomEvent
      return
  }, {


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