do ->
  window.Tok3nDashboard or= {}

  # easy refs for various things
  each = Function.prototype.call.bind [].forEach 
  indexOf = Function.prototype.call.bind [].indexOf 
  slice = Function.prototype.call.bind [].slice

  qs = document.querySelector.bind document 
  qsa = document.querySelectorAll.bind document 
  gebi = document.getElementById.bind document

  querySelectorAll = ( selector ) ->
    slice document.querySelectorAll selector


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

    Tok3nDashboard.slider()

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