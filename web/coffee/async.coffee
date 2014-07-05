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

  # Typekit
    load: "//use.typekit.net/nls8ikc.js"
    complete: ->
      try
        Typekit.load()
      return
  }, {
  
  # Google Charts
    load: "//www.google.com/jsapi"
    complete: ->
      google.load "visualization", "1",
        packages: ["corechart"]
        callback: ->
          drawChartDataDonut = (e) ->
            data = google.visualization.arrayToDataTable([
              ["Task", "Requests"]
              ["Valid", e.detail.ValidRequests]
              ["Invalid", e.detail.InvalidRequests]
              ["Pending", e.detail.IssuedRequests]
            ])
            options =
              title: "Request types"
              pieHole: 0.4
            chart = new google.visualization.PieChart(document.getElementById("donutChart"))
            chart.draw data, options
            google.visualization.events.addListener chart, "ready", ->
              resizeContent()
          drawChartDataRequestHistory = (e) ->
            data = google.visualization.arrayToDataTable(eval_(e.detail))
            console.log data
            options = title: "Requests"
            chart = new google.visualization.LineChart(document.getElementById("requestHistoryChart"))
            chart.draw data, options
            google.visualization.events.addListener chart, "ready", ->
              resizeContent()
          drawChartDataUsersHistory = (e) ->
            data = google.visualization.arrayToDataTable(eval_(e.detail))
            console.log data
            options = title: "Users"
            chart = new google.visualization.LineChart(document.getElementById("usersHistoryChart"))
            chart.draw data, options
            google.visualization.events.addListener chart, "ready", ->
              resizeContent()
          window.addEventListener "drawChartDataDonut", drawChartDataDonut, false
          window.addEventListener "drawChartDataRequestHistory", drawChartDataRequestHistory, false
          window.addEventListener "drawChartDataUsersHistory", drawChartDataUsersHistory, false
          return
      return
  }, {
  
  # Google Analytics
    load: ((if "https:" is location.protocol then "//ssl" else "//www")) + ".google-analytics.com/ga.js"
  }])