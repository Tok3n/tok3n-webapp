# Google Analytics
root = exports ? this
root._gaq = [['_setAccount', 'UA-39917560-2'], ['_trackPageview']]

Modernizr.addTest "csscalc", ->
  prop = "width:"
  value = "calc(10px);"
  el = document.createElement("div")
  el.style.cssText = prop + Modernizr._prefixes.join(value + prop)
  !!el.style.length

Modernizr.load([{
  test: Modernizr.mq
  nope: 'https://raw.githubusercontent.com/scottjehl/Respond/master/dest/respond.min.js'
}, {
  test: document.documentElement.classList
  nope: 'https://raw.githubusercontent.com/eligrey/classList.js/master/classList.min.js'
}, {
  test: Modernizr.flexbox and Modernizr.csscalc
  nope: ->
    Tok3nDashboard.compatibilityLayout()
}, {
  load: ((if "https:" is location.protocol then "//ssl" else "//www")) + ".google-analytics.com/ga.js"
}, {
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
  load: "//use.typekit.net/nls8ikc.js"
  complete: ->
    # console.log('typekit loading complete')
    try
      Typekit.load()
    return
}])