# easy refs for various things
each = Function.prototype.call.bind [].forEach 
indexOf = Function.prototype.call.bind [].indexOf 
slice = Function.prototype.call.bind [].slice

qs = document.querySelector.bind document 
qsa = document.querySelectorAll.bind document 
gebi = document.getElementById.bind document

querySelectorAll = ( selector ) ->
  slice document.querySelectorAll selector

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

##################################################################

# Functions
getStyle = (oElm, strCssRule) ->
  strValue = ""
  if document.defaultView and document.defaultView.getComputedStyle
    strValue = document.defaultView.getComputedStyle(oElm, "").getPropertyValue(strCssRule)
  else if oElm.currentStyle
    strCssRule = strCssRule.replace(/\-(\w)/g, (strMatch, p1) ->
      p1.toUpperCase()
    )
    strValue = oElm.currentStyle[strCssRule]
  strValue

##################################################################
# Huge hack to allow parent content element in the layout to have the same height as the .tok3n-pt-page-current. Don't forget to resizeContent() after changing the current page.
  
windowHeight = () ->
  $topHeight = null
  # We asume that matchMedia is supported
  if window.matchMedia("(min-width: 769px)").matches
    # Desktop size (render just the hack padding)
    $topHeight = parseInt(getStyle(document.querySelector('#tok3nLayout'), 'padding-top'), 10)
  else
    # Mobile size (render actual size)
    $topHeight = parseInt(getStyle(document.querySelector('#tok3nTop'), 'height'), 10)
  return window.innerHeight - $topHeight

contentHeight = () ->
  $contentHeight = null
  innerContentHeight = parseInt(getStyle(document.querySelector('.tok3n-pt-page-current .tok3n-main-content'), 'height'), 10)
  elemList = document.querySelector('.tok3n-pt-page-current .tok3n-main-list')
  if elemList?
    listHeight = parseInt(getStyle(elemList, 'height'), 10)
  else
    listHeight = 0
  # We asume that matchMedia is supported
  if window.matchMedia("(min-width: 769px)").matches
    # Desktop size
    $contentHeight = innerContentHeight
  else
    $contentHeight = innerContentHeight + listHeight
  return $contentHeight

resizeContent = () ->
  # Set the height of .tok3n-pt-perspective to the window height minus the top bar height.
  currentContent = document.querySelectorAll('.tok3n-pt-perspective, .tok3n-pt-page-current')  
  $windowHeight = windowHeight()
  $contentHeight = contentHeight()
  $topHeight = parseInt(getStyle(document.querySelector('#tok3nTop'), 'height'), 10)
  if $windowHeight > $contentHeight
    for el in currentContent
      el.style.height = $windowHeight + "px"
  else
    for el in currentContent
      el.style.height = $contentHeight + "px"
  return

# Keep resizing content onResize
window.addEventListener "resize", (event) ->
  resizeContent()
  return

##################################################################

main = () ->
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

  # Masonry apps container
  ((el) ->
    if el
      msnry = new Masonry(el, {
        itemSelector: '.card'
        gutter: '.grid-gutter'
      })
  )(document.querySelector '.tok3n-cards-container')

  # Set content height first time in Dart

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