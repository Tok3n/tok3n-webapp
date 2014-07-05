do ->

  compatibilityLayout = ->
    # $.unwrap .tok3n-pages-wrapper
    pagesWrapper = qs ".tok3n-pages-wrapper"
    while pagesWrapper.firstChild
      pagesWrapper.parentNode.insertBefore pagesWrapper.firstChild, pagesWrapper
    pagesWrapper.parentNode.removeChild pagesWrapper

    # Keep resizing content onResize
    window.addEventListener "resize", (event) ->
      resizeContent()
      return

    # Init first resize
    resizeContent()

    # Resize after the window slide animation
    ee.addListener 'tok3nSlideBAfterAnimation', ->
      resizeContent()
      # Masonry Layout Complete
      if Tok3nDashboard.masonry?
        Tok3nDashboard.masonry.on 'layoutComplete', ->
          resizeContent()

  #####################################################

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

  #####################################################
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

  Tok3nDashboard.compatibilityLayout = compatibilityLayout
  Tok3nDashboard.resizeContent = resizeContent