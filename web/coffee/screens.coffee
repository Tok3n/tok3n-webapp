do ->

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

      # Sidebar show/hide
      ((el) ->
        if el
          document.querySelector('#collapseSidebarButton').addEventListener 'click', () ->
            el.classList.toggle 'collapsed'
          
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
      submit = qs submitForm
      # Init form
      form.parsley
        classHandler: clsHandler
      # Create or redefine the handler
      Tok3nDashboard.formEventHandler = (evt) ->
        form.parsley().validate()
        formEvent = new CustomEvent 'submitValidatedForm',
          detail:
            validatedForm: form[0]
            isValid: form.parsley().isValid()
        window.dispatchEvent formEvent
      # Attach event
      submit.addEventListener 'click', Tok3nDashboard.formEventHandler
      # Log result
      if Tok3nDashboard.Environment.isDevelopment
        console.log "Added validated form #{formElement}"


    destroyParsleyForm = (formElement, submitForm, clsHandler) ->
      form = $(formElement)
      submit = qs submitForm
      # Destroy form
      form.parsley().destroy()
      # Deattach event
      submit.removeEventListener 'click', Tok3nDashboard.formEventHandler
      # Log result
      if Tok3nDashboard.Environment.isDevelopment
        console.log "Destroyed validated form #{formElement}"


    ###
    My devices
    ###

    exports.deviceNew3 = ->
      addNewParsleyForm('#deviceNew3Form', '#deviceNew3Submit', '#deviceNew3Form')


    exports.destroyDeviceNew3 = ->
      destroyParsleyForm('#deviceNew3Form', '#deviceNew3Submit', '#deviceNew3Form')


    ###
    My phonelines
    ###

    countrySelect = gebi "phonelineNew1CountrySelect"
    countryCode = gebi "phonelineNew1CountryCode"
    phoneNumber = gebi 'phonelineNew1PhoneNumber'

    selectCountryCode = ( evt ) ->
      el = evt.target
      countryCodeValue = el.options[el.selectedIndex].value
      countryCode.innerHTML = "+#{countryCodeValue}"


    toggleNextButton = ( evt ) ->
      el = evt.target
      parentEl = findClosestAncestor el, "tok3n-dashboard-form-lower-wrapper"
      button = parentEl.nextSibling.querySelector('.tok3n-dashboard-main-button')
      if el.checkValidity() or !isEmptyOrDefault el
        button.disabled = false
      else
        button.disabled = true


    toggleNextButtonOtp = ( evt ) ->
      el = evt.target
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
      phoneNumber.addEventListener "keyup", toggleNextButton
      # Change country code on country change
      countrySelect.addEventListener 'change', selectCountryCode

    exports.destroyPhonelineNew1 = ->
      phoneNumber.removeEventListener "keyup", toggleNextButton
      countrySelect.addEventListener 'change', selectCountryCode


    exports.phonelineNew2 = ->
      signupOtpInput = gebi 'phonelineNew2OtpInput'
      signupOtpInput.addEventListener 'keyup', toggleNextButtonOtp
      signupOtpInput.addEventListener "input", limitToSixChar

    exports.destroyPhonelineNew2 = ->
      signupOtpInput.removeEventListener 'keyup', toggleNextButtonOtp


    exports.phonelineNew3 = ->
      addNewParsleyForm('#tok3nPhonelineNew3Form', '#tok3nPhonelineNew3Submit', '#tok3nPhonelineNew3Form')
    
    exports.destroyPhonelineNew3 = ->
      destroyParsleyForm('#tok3nPhonelineNew3Form', '#tok3nPhonelineNew3Submit', '#tok3nPhonelineNew3Form')


    ###
    My applications
    ###

    cardsContainer = qs '.tok3n-cards-container'


    flipCardToBack = (evt) ->
      el = evt.target
      findClosestAncestor(el, 'flipper').classList.add 'flipped'
      card = [].filter.call el.parentNode.children, (gl) ->
        gl.classList.contains('back')
      forEach card, (fl) ->
        fl.style.zIndex = 3


    flipCardToFront = (evt) ->
      findClosestAncestor(evt.target, 'flipper').classList.remove 'flipped'


    exports.applications = ->
      # Masonry apps container
      if cardsContainer
        Tok3nDashboard.masonry = new Masonry cardsContainer,
          itemSelector: '.card'
          gutter: '.grid-gutter'
      # Flip cards to the back
      forEach cardsContainer.querySelectorAll('.front'), (el) ->
        el.addEventListener 'click', flipCardToBack
      # Flip cards to the front
      forEach cardsContainer.querySelectorAll('.flip'), (el) ->
        el.addEventListener 'click', flipCardToFront


    destroyMasonry = ->
      if Tok3nDashboard.masonry
        if Tok3nDashboard.masonry.isResizeBound
          Tok3nDashboard.masonry.destroy()
          if Tok3nDashboard.Environment.isDevelopment
            console.log 'Destroyed masonry.'


    exports.destroyApplications = ->
      destroyMasonry()
      # Flip cards to the back
      forEach cardsContainer.querySelectorAll('.front'), (el) ->
        el.removeEventListener 'click', flipCardToBack
      # Flip cards to the front
      forEach cardsContainer.querySelectorAll('.flip'), (el) ->
        el.removeEventListener 'click', flipCardToFront


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
            if Tok3nDashboard.Environment.isDevelopment
              console.log data
            options =
              title: "Request types"
              pieHole: 0.4
            chart = new google.visualization.PieChart(document.getElementById("donutChart"))
            chart.draw data, options
          drawChartDataRequestHistory = (e) ->
            data = google.visualization.arrayToDataTable(eval_(e.detail))
            if Tok3nDashboard.Environment.isDevelopment
              console.log data
            options = title: "Requests"
            chart = new google.visualization.LineChart(document.getElementById("requestHistoryChart"))
            chart.draw data, options
          drawChartDataUsersHistory = (e) ->
            data = google.visualization.arrayToDataTable(eval_(e.detail))
            if Tok3nDashboard.Environment.isDevelopment
              console.log data
            options = title: "Users"
            chart = new google.visualization.LineChart(document.getElementById("usersHistoryChart"))
            chart.draw data, options
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

          if namespaceExists(google, 'visualization')
            google.visualization.events.addListener chart, "ready", ->
              if Tok3nDashboard.compatibilityLayout
                Tok3nDashboard.resizeContent()

      # If the promise exists and charts
      if Tok3nDashboard.Jsapi.isLoaded
        attachChartFunctions()
      # Wait until it exists
      else
        ee.addListener('tok3nJsapiPromiseCreated', attachChartFunctions)


    toggleSecret = (ev) ->
      el = ev.target
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


    dropdownList = (ev) ->
      for child in ev.target.children
        if child.classList.contains 'dropdown-menu'
          child.classList.toggle 'dropdown-show'


    exports.integrationView = ->
      # Toggle secrets
      toggleEl = querySelectorAll '.toggle-secret'
      if toggleEl
        toggleEl.forEach (el) ->
          el.addEventListener 'click', toggleSecret
      # Dropdown lists
      dropdowns = querySelectorAll '.dropdown'
      if dropdowns
        dropdowns.forEach (el) ->
          el.addEventListener 'click', dropdownList


    exports.destroyIntegrationView = ->
      # Toggle secrets
      toggleEl = querySelectorAll '.toggle-secret'
      if toggleEl
        toggleEl.forEach (el) ->
          el.removeEventListener 'click', toggleSecret
      # Dropdown lists
      dropdowns = querySelectorAll '.dropdown'
      if dropdowns
        dropdowns.forEach (el) ->
          el.removeEventListener 'click', dropdownList


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


    destroyButtonFilePathCompletion = ->
      $(document).off "change", ".btn-file :file"
      $(".btn-file :file").off "fileselect"


    showHideCallback = (evt) ->
      callbackField = qs '.tok3n-new-integration-callback-url'
      callbackInput = gebi 'integrationNewCallbackUrl'
      showCallback = ->
        callbackField.classList.remove 'collapsed'
        callbackInput.setAttribute 'data-parsley-required', 'true'
      hideCallback = ->
        callbackField.classList.add 'collapsed'
        callbackInput.setAttribute 'data-parsley-required', 'false'
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
        if evt.target.id is 'integrationNewKindWeb'
          showCallback()
        else if evt.target.id is 'integrationNewKindGeneral'
          hideCallback()


    newIntegrationRadio = querySelectorAll '.tok3n-new-integration-kind-radio, .tok3n-new-integration-kind-radio input'


    exports.integrationNew = ->
      newIntegrationRadio.forEach (el) ->
        el.addEventListener 'click', showHideCallback
      buttonFilePathCompletion()
      addNewParsleyForm('#integrationNewForm', '#integrationNewSubmit', '#integrationNewForm')


    exports.destroyIntegrationNew = ->
      newIntegrationRadio.forEach (el) ->
        el.removeEventListener 'click', showHideCallback
      destroyButtonFilePathCompletion()
      destrayParsleyForm('#integrationNewForm', '#integrationNewSubmit', '#integrationNewForm')


    exports.integrationEdit = ->
      addNewParsleyForm('#integrationEditForm', '#integrationEditSubmit', '#integrationEditForm')
      buttonFilePathCompletion()


    exports.destroyIntegrationEdit = ->
      destroyParsleyForm('#integrationEditForm', '#integrationEditSubmit', '#integrationEditForm')
      destroyButtonFilePathCompletion()


    ###
    Settings
    ###

    passwordField = gebi 'tok3nUserPassword'
    verifyPassword = qs '.tok3n-user-verify-password'
    verifyPasswordField = gebi 'tok3nUserVerifyPassword'


    toggleVerifyPassword = ->
      if passwordField
        if passwordField.value
          verifyPassword.classList.remove "collapsed"
          verifyPasswordField.setAttribute 'data-parsley-required', 'true'
        else
          verifyPassword.classList.add "collapsed"
          verifyPasswordField.setAttribute 'data-parsley-required', 'false'


    exports.settings = ->
      toggleVerifyPassword()
      passwordField.addEventListener 'keyup', toggleVerifyPassword
      addNewParsleyForm('#tok3nSettingsForm', '#tok3nSettingsSubmit', '#tok3nSettingsForm')


    exports.destroySettings = ->
      passwordField.removeEventListener 'keyup', toggleVerifyPassword
      destroyParsleyForm('#tok3nSettingsForm', '#tok3nSettingsSubmit', '#tok3nSettingsForm')