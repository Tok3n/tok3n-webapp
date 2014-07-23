do ->

  Tok3nDashboard.Screens or= {}
  Tok3nDashboard.initWindow or= 'Devices'

  namespace 'Tok3nDashboard.Screens', (exports) ->

    ###
    Sitewide
    ###

    exports.sitewide = ->
      # Set active window
      current = capitaliseFirstLetter Tok3nDashboard.initWindow
      document.getElementById("tok3n#{current}").classList.add 'tok3n-pt-page-current'
      document.getElementById("tok3n#{current}MenuButton").classList.add 'tok3n-sidebar-selected'

      # Avoid the browser going to # for each a element
      querySelectorAll('a[href="#"]').forEach (el) ->
        el.addEventListener 'click', (evt) ->
          evt.preventDefault()
        , false

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


    addNewParsleyForm = (formElement, submitForm, clsHandler) ->
      form = $(formElement)
      form.parsley
        classHandler: clsHandler
      Tok3nDashboard.ValidatedForms.push form
      
      submit = qs submitForm
      submit.addEventListener 'click', (evt) ->
        form.parsley().validate()
        if Tok3nDashboard.Environment.isDevelopment
          console.log form.parsley().isValid()
      , false


    ###
    My devices
    ###

    exports.deviceNew3 = ->
      addNewParsleyForm('#tok3nDeviceNew3Form', '#tok3nDeviceNew3Submit', '#tok3nDeviceNew3Form')


    ###
    My phonelines
    ###

    countrySelect = gebi "countrySelect"
    countryCode = gebi "countryCode"
    phoneNumber = gebi 'phoneNumber'

    selectCountryCode = ( el ) ->
      countryCodeValue = el.options[el.selectedIndex].value
      countryCode.innerHTML = "+#{countryCodeValue}"


    toggleNextButton = ( el ) ->
      parentEl = findClosestAncestor el, "tok3n-dashboard-form-lower-wrapper"
      button = parentEl.nextSibling.querySelector('.tok3n-dashboard-main-button')
      if el.checkValidity() or !isEmptyOrDefault el
        button.disabled = false
      else
        button.disabled = true


    toggleNextButtonOtp = ( el ) ->
      parentEl = findClosestAncestor el, "tok3n-dashboard-new-form"
      button = parentEl.querySelector('.tok3n-dashboard-main-button')
      if hasFormValidation()
        if el.checkValidity() and el.value.length is 6
          button.disabled = false
        else
          button.disabled = true
      else
        if el.value.length is 6
          button.disabled = false
        else
          button.disabled = true


    limitToSixChar = ->
      if this.value.length > 6
        this.value = this.value.slice 0, 6


    exports.phonelineNew1 = ->
      # Init country code selector
      selectCountryCode(countrySelect)

      # Enable phone number next button
      phoneNumber.addEventListener "keyup", (evt) ->
        toggleNextButton(evt.target)

      # Change country code on country change
      countrySelect.addEventListener 'change', (evt) ->
        selectCountryCode(evt.target)


    exports.phonelineNew2 = ->
      signupOtpInput = gebi 'tok3nOtpInput'
      signupOtpInput.addEventListener 'keyup', (evt) ->
        toggleNextButtonOtp(evt.target)
      signupOtpInput.addEventListener "input", limitToSixChar


    exports.phonelineNew3 = ->
      addNewParsleyForm('#tok3nPhonelineNew3Form', '#tok3nPhonelineNew3Submit', '#tok3nPhonelineNew3Form')


    ###
    My applications
    ###

    exports.applications = ->
      cardsContainer = qs '.tok3n-cards-container'

      # Masonry apps container
      if cardsContainer
        Tok3nDashboard.masonry = new Masonry cardsContainer,
          itemSelector: '.card'
          gutter: '.grid-gutter'

      # Flip cards to the back
      forEach cardsContainer.querySelectorAll('.front'), (el) ->
        el.addEventListener 'click', ->
          findClosestAncestor(el, 'flipper').classList.add 'flipped'
          card = [].filter.call el.parentNode.children, (gl) ->
            gl.classList.contains('back')
          forEach card, (fl) ->
            fl.style.zIndex = 3
        , false

      # Flip cards to the front
      forEach cardsContainer.querySelectorAll('.flip'), (el) ->
        el.addEventListener 'click', ->
          findClosestAncestor(el, 'flipper').classList.remove 'flipped'
        , false


    ###
    My integrations
    ###

    exports.integrationsCharts = ->
      # Attach chart functions once the jsapi is loaded, using a promise.
      attachChartFunctions = ->
        Tok3nDashboard.Jsapi.isLoaded.then ->
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
          
          # Set var to prevent loading twice
          Tok3nDashboard.Charts.areLoaded = true

          if Tok3nDashboard.Environment.isDevelopment
            console.log('Chart functions attached successfully.')

          # Dispatch event for dealing with the chart
          chartEvent = new CustomEvent 'chartFunctionsLoaded'
          window.dispatchEvent chartEvent
          return

      # If the promise exists and charts
      if Tok3nDashboard.Jsapi.isLoaded
        attachChartFunctions()
      # Wait until it exists
      else
        ee.addListener('tok3nJsapiPromiseCreated', attachChartFunctions)


    exports.integrationView = ->
      # Toggle secrets
      toggleEl = qsa '.toggle-secret'
      if toggleEl?
        forEach toggleEl, (el) ->
          el.addEventListener 'click', (ev) ->
            ev.preventDefault()
            hiddenEl = [].filter.call el.parentNode.children, (gl) ->
              gl.classList.contains('secret')
            if hiddenEl?
              forEach hiddenEl, (fl) ->
                if fl.classList.contains 'hidden'
                  el.innerHTML = 'hide'
                  fl.classList.remove 'hidden'
                else unless fl.classList.contains 'hidden'
                  el.innerHTML = 'show'
                  fl.classList.add 'hidden'
          , false

      # Dropdown lists
      dropdowns = querySelectorAll '.dropdown'
      if dropdowns
        dropdowns.forEach (el) ->
          el.addEventListener 'click', () ->
            for child in el.children
              if child.classList.contains 'dropdown-menu'
                child.classList.toggle 'dropdown-show'
          , false


    buttonFilePathCompletion = ->
      $(document).on "change", ".btn-file :file", ->
        input = $(this)
        numFiles = (if input.get(0).files then input.get(0).files.length else 1)
        pattern = ///
          \\
        ///g
        label = input.val().replace(pattern, "/").replace(/.*\//, "")
        input.trigger "fileselect", [
          numFiles
          label
        ]
        return
      $(".btn-file :file").on "fileselect", (event, numFiles, label) ->
        input = $(this).parents(".input-group").find(":text")
        log = (if numFiles > 1 then numFiles + " files selected" else label)
        if input.length
          input.val log
        else
          alert log  if log
        return


    exports.integrationNew = ->
      newIntegrationRadio = querySelectorAll '.tok3n-new-integration-kind-radio, .tok3n-new-integration-kind-radio input'
      callbackField = qs '.tok3n-new-integration-callback-url'
      callbackInput = gebi 'tokenIntegrationCallbackUrl'
      showCallback = ->
        callbackField.classList.remove 'collapsed'
        callbackInput.setAttribute 'data-parsley-required', 'true'
      hideCallback = ->
        callbackField.classList.add 'collapsed'
        callbackInput.setAttribute 'data-parsley-required', 'false'
      
      newIntegrationRadio.forEach (el) ->
        el.addEventListener 'click', (evt) ->
          evt.stopPropagation()
          if evt.target.classList.contains 'tok3n-new-integration-kind-radio-web'
            evt.preventDefault()
            evt.target.querySelector('input').checked = true
            showCallback()
          else if evt.target.classList.contains 'tok3n-new-integration-kind-radio-general'
            evt.preventDefault()
            evt.target.querySelector('input').checked = true
            hideCallback()
          else
            if evt.target.id is 'newIntegrationKindWeb'
              showCallback()
            else if evt.target.id is 'newIntegrationKindGeneral'
              hideCallback()
        , false

      buttonFilePathCompletion()

      addNewParsleyForm('#tok3nIntegrationNewForm', '#tok3nIntegrationNewSubmit', '#tok3nIntegrationNewForm')


    exports.integrationEdit = ->
      addNewParsleyForm('#tok3nIntegrationEditForm', '#tok3nIntegrationEditSubmit', '#tok3nIntegrationEditForm')

      buttonFilePathCompletion()


    ###
    Settings
    ###

    toggleVerifyPassword = ->
      passwordField = qs "input.tok3n-user-password"
      verifyPassword = qs '.tok3n-user-verify-password'
      verifyPasswordField = gebi 'tok3nUserVerifyPassword'
      if passwordField
        if passwordField.value
          verifyPassword.classList.remove "collapsed"
          verifyPasswordField.setAttribute 'data-parsley-required', 'true'
        else
          verifyPassword.classList.add "collapsed"
          verifyPasswordField.setAttribute 'data-parsley-required', 'false'


    exports.settings = ->
      toggleVerifyPassword()
      
      document.querySelector('.tok3n-user-password').addEventListener 'keyup', ( event ) ->
        toggleVerifyPassword()
      , false

      addNewParsleyForm('#tok3nSettingsForm', '#tok3nSettingsSubmit', '#tok3nSettingsForm')