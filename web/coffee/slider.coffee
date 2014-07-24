do ->

  ###
  Sliding login window
  ###

  animationClasses = ['tok3n-move-from-left', 'tok3n-move-to-left', 'tok3n-move-from-right', 'tok3n-move-to-right']
  removeAnimationClasses = ( el ) ->
    each animationClasses, ( cl ) ->
      el.classList.remove( cl )

  slider = ->
    options = querySelectorAll "#tok3nSidebarMenu li"
    menuItemAnchorClass = "tok3n-menu-item"
    menuItemSelectedClass = "tok3n-sidebar-selected"
    previousOption = qs "#tok3nSidebarMenu li.#{menuItemSelectedClass}"
    previousTargetId = previousOption.getAttribute( "data-target" ).toString()
    previousTarget = gebi previousTargetId

    options.forEach ( el ) ->
      el.addEventListener "click", ( evt ) ->
        nextOption = if evt.target.classList.contains menuItemAnchorClass then evt.target else findClosestAncestor evt.target, menuItemAnchorClass
        if previousOption isnt nextOption
          previousOption.classList.remove menuItemSelectedClass
          nextOption.classList.add menuItemSelectedClass
        nextTargetId = nextOption.getAttribute( "data-target" ).toString()
        nextTarget = gebi nextTargetId
        temp = undefined

        # We need to be careful handling output from this.
        # Returning empty strings & concating them to other stuff produces
        # CSS class names we're not handling currently.
        # this returns false if indexes are equal
        animationSlide = ( option ) ->
          return unless option in ["previous", "next"]
          if childNodeIndex( nextOption ) < childNodeIndex( previousOption )
            if option is "previous" then "left" else "right"
          else if childNodeIndex( nextOption ) > childNodeIndex( previousOption )
            if option is "previous" then "right" else "left"
          else
            return false

        # If the clicked option is different than the currently selected
        if childNodeIndex( nextOption ) isnt childNodeIndex( previousOption )
          removeAnimationClasses( previousTarget )

          Tok3nDashboard.nextTarget = nextTarget
          Tok3nDashboard.previousTarget = previousTarget

          ee.emitEvent 'tok3nSlideBeforeAnimation'

          previousTarget.classList.add( "tok3n-move-to-#{ animationSlide( 'previous' ) }" )
          temp = previousTarget

          setTimeout ->
            temp.classList.remove "tok3n-pt-page-previous"
            temp.classList.remove "tok3n-pt-page-current"
            Tok3nDashboard.tempPreviousTarget = temp
            ee.emitEvent 'tok3nSlideAfterAnimation'
          , 250

          removeAnimationClasses( nextTarget )

          nextTarget.classList.add "tok3n-pt-page-current"
          nextTarget.classList.add "tok3n-move-from-#{ animationSlide( 'next' ) }"

        previousOption = nextOption
        previousTargetId = previousOption.getAttribute( "data-target" ).toString()
        previousTarget = gebi previousTargetId
      return
    return

  Tok3nDashboard.slider = slider