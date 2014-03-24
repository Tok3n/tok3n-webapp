# Google Analytics
root = exports ? this
root._gaq = [['_setAccount', 'UA-39917560-2'], ['_trackPageview']]

# Async loading
# Add pollyfills: queryselector, matchmedia, classlist
Modernizr.load([{
  test: Modernizr.mq
  nope: 'https://raw.githubusercontent.com/scottjehl/Respond/master/dest/respond.min.js'
}, {
  test: document.documentElement.classList
  nope: 'https://raw.githubusercontent.com/eligrey/classList.js/master/classList.min.js'
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
        drawChartDataRequestHistory = (e) ->
          data = google.visualization.arrayToDataTable(eval_(e.detail))
          console.log data
          options = title: "Requests"
          chart = new google.visualization.LineChart(document.getElementById("requestHistoryChart"))
          chart.draw data, options
        drawChartDataUsersHistory = (e) ->
          data = google.visualization.arrayToDataTable(eval_(e.detail))
          console.log data
          options = title: "Users"
          chart = new google.visualization.LineChart(document.getElementById("usersHistoryChart"))
          chart.draw data, options
        window.addEventListener "drawChartDataDonut", drawChartDataDonut, false
        window.addEventListener "drawChartDataRequestHistory", drawChartDataRequestHistory, false
        window.addEventListener "drawChartDataUsersHistory", drawChartDataUsersHistory, false
}, {
  load: "//use.typekit.net/nls8ikc.js"
  complete: ->
    # console.log('typekit loading complete')
    try
      Typekit.load()
    return
}])

##################################################################

main = () ->
  # Sidebar show/hide
  ((el) ->
    if el
      document.querySelector('#collapseSidebarButton').addEventListener('click', () ->
        el.classList.toggle 'collapsed'
      , false)
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
  )(document.querySelector '#sidebarMenu')
  
  # Prevent scroll past the central #list, doesn't work in old browsers
  ((el) ->
    preventScrollPastElem = (ev) ->
      WidthChange = (mq) ->
        if mq.matches
          # Desktop size
          ev.target.scrollTop -= ev.wheelDeltaY
          ev.preventDefault()
        return
      if matchMedia
        mq = window.matchMedia("(min-width: 769px)")
        mq.addListener WidthChange
        WidthChange mq
      return
    if el
      el.addEventListener('mousewheel', (event) ->
        preventScrollPastElem(event)
      , false)
  )(document.querySelector '#list')

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

  # Masonry apps container
  ((el) ->
    if el
      msnry = new Masonry(el, {
        itemSelector: '.card'
        gutter: '.grid-gutter'
      })
  )(document.querySelector '#cards-container')
  return

##################################################################

# Vanilla $('document').ready() detection. Execute main() when it is.
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