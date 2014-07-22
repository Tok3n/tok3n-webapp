do ->

  Tok3nDashboard.Screens or= {}
  Tok3nDashboard.initWindow or= 'Devices'

  namespace 'Tok3nDashboard.Screens', (exports) ->

    ###
    Sitewide
    ###

    exports.sitewide = ->
      # Set active window
      current = Tok3nDashboard.initWindow
      document.getElementById("tok3n#{current}").classList.add 'tok3n-pt-page-current'
      document.getElementById("tok3n#{current}MenuButton").classList.add 'tok3n-sidebar-selected'


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
      ((arr) ->
        if arr
          for el in arr
            el.addEventListener('click', () ->
              for child in el.children
                if child.classList.contains 'dropdown-menu'
                  child.classList.toggle 'dropdown-show'
            , false)
      )(document.querySelectorAll '.dropdown')

    exports.integrationNew = ->
      newIntegrationRadio = querySelectorAll '.tok3n-new-integration-kind-radio, .tok3n-new-integration-kind-radio input'
      callbackField = qs '.tok3n-new-integration-callback-url'
      
      newIntegrationRadio.forEach (el) ->
        
        el.addEventListener 'click', (evt) ->
          evt.stopPropagation()
          if evt.target.classList.contains 'tok3n-new-integration-kind-radio-web'
            evt.preventDefault()
            evt.target.querySelector('input').checked = true
            # Show callback
            callbackField.classList.remove 'collapsed'
          else if evt.target.classList.contains 'tok3n-new-integration-kind-radio-general'
            evt.preventDefault()
            evt.target.querySelector('input').checked = true
            # hide callback
            callbackField.classList.add 'collapsed'
          else
            if evt.target.id is 'newIntegrationKindWeb'
              # Show callback
              callbackField.classList.remove 'collapsed'
            else if evt.target.id is 'newIntegrationKindGeneral'
              # hide callback
              callbackField.classList.add 'collapsed'
        , false


    ###
    Settings
    ###

    toggleVerifyPassword = ->
      passwordField = qs "input.tok3n-user-password"
      verifyPassword = qs '.tok3n-user-verify-password'
      if passwordField
        if passwordField.value
          verifyPassword.classList.remove "collapsed"
        else
          verifyPassword.classList.add "collapsed"

    exports.settings = ->
      toggleVerifyPassword()
      document.querySelector('.tok3n-user-password').addEventListener 'keyup', ( event ) ->
        toggleVerifyPassword()
      , false