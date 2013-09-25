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
google.load "visualization", "1",
  packages: ["corechart"]

window.addEventListener "drawChartDataDonut", drawChartDataDonut, false
window.addEventListener "drawChartDataRequestHistory", drawChartDataRequestHistory, false
window.addEventListener "drawChartDataUsersHistory", drawChartDataUsersHistory, false

#####################################################################################
#####################################################################################

ee = new EventEmitter()
window.addEventListener "ee", ee, false

$(document).on "DOMMouseScroll mousewheel", "#list", (ev) ->
  $this = $(this)
  scrollTop = @scrollTop
  scrollHeight = @scrollHeight
  height = $this.height()
  delta = ((if ev.type is "DOMMouseScroll" then ev.originalEvent.detail * -40 else ev.originalEvent.wheelDelta))
  up = delta > 0
  prevent = ->
    ev.stopPropagation()
    ev.preventDefault()
    ev.returnValue = false
    false
  if not up and -delta > scrollHeight - height - scrollTop
    $this.scrollTop scrollHeight
    prevent()
  else if up and delta > scrollTop
    $this.scrollTop 0
    prevent()

masonryResize = (e) ->
  eachCard = $('#cards-container .card')
  eachCardFlippingContent = $('#cards-container .card .front, #cards-container .card .back, #cards-container .card')
  eachCardFrontBack = $('#cards-container .card .front, #cards-container .card .back')
  cardWidth = eachCard.width()
  eachCardFlippingContent.height(cardWidth)
  eachCardFrontBack.width(cardWidth)
window.addEventListener "resizeend", masonryResize, false

$(document).ready ->
  # Integration page api secret toggle
  secret = $('.toggle-secret')
  secret.click ->
    $('.secret').toggle()
    if secret.html() is 'show' then secret.html('hide') else secret.html('show')
  # New integration web options toggle
  webtoggle = $('#popup-new-integration .web-toggle')
  radiobutton = $('#popup-new-integration input[type=radio]')
  radiobutton.click (e) ->
    value = $(e.currentTarget).val()
    if value is 'web' then webtoggle.slideDown() else webtoggle.slideUp()
  # Masonry resize before calling for the first time
  masonryResize()
  $('#cards-container').masonry
    itemSelector: '.card'
    columnWidth: '.grid-column'
    gutter: '.grid-gutter'
    transitionDuration: 0
  # Card flip
  $('#cards-container .flipper:not(.flipped)').parent().click ->
    $('.flipper', this).toggleClass('flipped')
  $('#cards-container .flip').click ->
    $(this).parent('.flipper').toggleClass('flipped')
  # Sidebar collapse responsive
  enquire.register "(min-width: 769px)", {
    match: ->
      $('#sidebar .menu').collapse 'show'
      false
    unmatch: ->
      $('#sidebar .menu').collapse 'hide'
      false

  },true

  $(".white-popup .popup-form").submit ->
    # On submit disable its submit button
    $("input[type=submit]", this).attr "disabled", "disabled"
    false
    

openPopup = (e) ->
  $.magnificPopup.open
    items:
      src: e.detail.content # Content or css selector of container
      type: 'inline'
  false
closePopup = ->
  $.magnificPopup.close()
  false
window.addEventListener "openPopup", openPopup, false
window.addEventListener "closePopup", closePopup, false
