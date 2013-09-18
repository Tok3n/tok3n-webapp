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

ee = new EventEmitter()
delay = (ms, func) -> setTimeout func, ms
isFirstIntegration = false
displayedFirstTour = false
submitOnFirstTour = false

$ ->
  STEPS = [
    {
      # Step 1
      content: "<h4 class=\"title\">Create your first integration</h4></div>" + "<p class=\"action\">" + "Click the <i>New integration</i> button in the left menu." + "</p>"
      highlightTarget: true
      my: "left center"
      at: "right center"
      target: $("#new-integration")
      bind: ['onClick']
      onClick: (tour) ->
        ee.once 'addedIntegration', ->
          tour.next()
          true
        false
      setup: (tour, options) ->
        $('#new-integration').on 'click', @onClick
        false
      teardown: (tour, options) ->
        $('#new-integration').off 'click', @onClick
        false
    }
    {
      # Step 2
      content: "<h4 class=\"title\">Hi there</h4>" + "<p class=\"action\">" + "Click the <i>New integration</i> button in the left menu." + "</p>"
      highlightTarget: true
      my: "left bottom"
      at: "right center"
      target: $("#popup-new-integration")
      setup: (tour, options) ->
        ee.addListener 'closedIntegrationWindow', ->
          displayedFirstTour = true
          tour.stop(false)
          true
        ee.once 'submitNewIntegration', ->
          tour.next()
          true
        false
    }
  ]

  SUCCESS = {
    # Final step after a successful run through
    content: "<p>If you need to change something you can do it here.</p>"
    closeButton: true
    nextButton: true
    highlightTarget: true
    my: "left center"
    at: "right center"
    target: $("#main .specs")
    teardown: (tour) ->
      displayedFirstTour = true
  }

  TOUR = new Tourist.Tour(
    tipClass: "Bootstrap"
    steps: STEPS
    successStep: SUCCESS
    tipOptions:
      showEffect: 'slidein'
  )
  if isFirstIntegration then TOUR.start()

$(document).ready ->
  secret = $('.toggle-secret')
  secret.click ->
    $('.secret').toggle()
    if secret.html() is 'show' then secret.html('hide') else secret.html('show')

  webtoggle = $('#popup-new-integration .web-toggle')
  radiobutton = $('#popup-new-integration input[type=radio]')

  radiobutton.click (e) ->
    value = $(e.currentTarget).val()
    if value is 'web' then webtoggle.slideDown() else webtoggle.slideUp()

  $('.popup-trigger').magnificPopup
    type: 'inline'
    callbacks:
      open: ->
        self = this
        ee.emitEvent 'addedIntegration' unless displayedFirstTour
        $('.popover').hide()
        $('#popup-new-integration').submit (e) ->
          submitOnFirstTour = true
          e.preventDefault()
          # Send data to Angel here and trigger event
          self.close()
        false
      beforeClose: ->
        $('.popover').show()
        false
      close: ->
        if submitOnFirstTour then ee.emitEvent 'submitNewIntegration' else ee.emitEvent 'closedIntegrationWindow' unless displayedFirstTour
        $('#popup-new-integration').unbind 'submit'
        false
  
  $('#newImplementationAvatar').change ->
    label = $(this).val().replace(/(\\)/g, "/").replace(/.*\//, "")
    $('.avatar-path').attr 'placeholder', label

# $('#popup-new-integration').on "change", ".btn-file :file", ->
#   input = $(this)
#   numFiles = (if input.get(0).files then input.get(0).files.length else 1)
#   label = input.val().replace(/\\/g, "/").replace(/.*\//, "")
#   input.trigger "fileselect", [numFiles, label]
