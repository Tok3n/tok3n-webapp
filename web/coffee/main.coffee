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

# Variables
currentContent = document.querySelectorAll('.tok3n-pt-perspective, .tok3n-pt-page-current')  

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

windowHeight = () ->
  $topHeight = null
  # We asume that matchMedia is supported
  if window.matchMedia("(min-width: 769px)").matches
    # Desktop size (render just the hack padding)
    $topHeight = parseInt(getStyle(document.querySelector('#layout'), 'padding-top'), 10)
  else
    # Mobile size (render actual size)
    $topHeight = parseInt(getStyle(document.querySelector('#top'), 'height'), 10)

  return window.innerHeight - $topHeight

contentHeight = () ->
  $contentHeight = null
  innerContentHeight = parseInt(getStyle(document.querySelector('.tok3n-pt-page-current .tok3n-main-content'), 'height'), 10)
  listHeight = parseInt(getStyle(document.querySelector('#list'), 'height'), 10)
  # We asume that matchMedia is supported
  if window.matchMedia("(min-width: 769px)").matches
    # Desktop size
    $contentHeight = innerContentHeight
  else
    $contentHeight = innerContentHeight + listHeight
  return $contentHeight

resizeContent = () ->
  # Set the height of .tok3n-pt-perspective to the window height minus the top bar height.
  $windowHeight = windowHeight()
  $contentHeight = contentHeight()
  $topHeight = parseInt(getStyle(document.querySelector('#top'), 'height'), 10)
  if $windowHeight > $contentHeight
    for el in currentContent
      el.style.height = $windowHeight + "px"
      # el.style.height = (window.innerHeight - $topHeight) + "px"
  else
    for el in currentContent
      el.style.height = $contentHeight + "px"

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
          # Remove height
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

  # Set content height first time
  resizeContent()

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

##################################################################
# Custom events

# Keep resizing content onResize
window.addEventListener "resize", (event) ->
  resizeContent()
  return