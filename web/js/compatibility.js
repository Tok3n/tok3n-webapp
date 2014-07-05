(function() {
  var compatibilityLayout, contentHeight, getStyle, resizeContent, windowHeight;
  compatibilityLayout = function() {
    var pagesWrapper;
    pagesWrapper = qs(".tok3n-pages-wrapper");
    while (pagesWrapper.firstChild) {
      pagesWrapper.parentNode.insertBefore(pagesWrapper.firstChild, pagesWrapper);
    }
    pagesWrapper.parentNode.removeChild(pagesWrapper);
    window.addEventListener("resize", function(event) {
      resizeContent();
    });
    resizeContent();
    return ee.addListener('tok3nSlideBAfterAnimation', function() {
      resizeContent();
      if (Tok3nDashboard.masonry != null) {
        return Tok3nDashboard.masonry.on('layoutComplete', function() {
          return resizeContent();
        });
      }
    });
  };
  getStyle = function(oElm, strCssRule) {
    var strValue;
    strValue = "";
    if (document.defaultView && document.defaultView.getComputedStyle) {
      strValue = document.defaultView.getComputedStyle(oElm, "").getPropertyValue(strCssRule);
    } else if (oElm.currentStyle) {
      strCssRule = strCssRule.replace(/\-(\w)/g, function(strMatch, p1) {
        return p1.toUpperCase();
      });
      strValue = oElm.currentStyle[strCssRule];
    }
    return strValue;
  };
  windowHeight = function() {
    var $topHeight;
    $topHeight = null;
    if (window.matchMedia("(min-width: 769px)").matches) {
      $topHeight = parseInt(getStyle(document.querySelector('#tok3nLayout'), 'padding-top'), 10);
    } else {
      $topHeight = parseInt(getStyle(document.querySelector('#tok3nTop'), 'height'), 10);
    }
    return window.innerHeight - $topHeight;
  };
  contentHeight = function() {
    var $contentHeight, elemList, innerContentHeight, listHeight;
    $contentHeight = null;
    innerContentHeight = parseInt(getStyle(document.querySelector('.tok3n-pt-page-current .tok3n-main-content'), 'height'), 10);
    elemList = document.querySelector('.tok3n-pt-page-current .tok3n-main-list');
    if (elemList != null) {
      listHeight = parseInt(getStyle(elemList, 'height'), 10);
    } else {
      listHeight = 0;
    }
    if (window.matchMedia("(min-width: 769px)").matches) {
      $contentHeight = innerContentHeight;
    } else {
      $contentHeight = innerContentHeight + listHeight;
    }
    return $contentHeight;
  };
  resizeContent = function() {
    var $contentHeight, $topHeight, $windowHeight, currentContent, el, _i, _j, _len, _len1;
    currentContent = document.querySelectorAll('.tok3n-pt-perspective, .tok3n-pt-page-current');
    $windowHeight = windowHeight();
    $contentHeight = contentHeight();
    $topHeight = parseInt(getStyle(document.querySelector('#tok3nTop'), 'height'), 10);
    if ($windowHeight > $contentHeight) {
      for (_i = 0, _len = currentContent.length; _i < _len; _i++) {
        el = currentContent[_i];
        el.style.height = $windowHeight + "px";
      }
    } else {
      for (_j = 0, _len1 = currentContent.length; _j < _len1; _j++) {
        el = currentContent[_j];
        el.style.height = $contentHeight + "px";
      }
    }
  };
  Tok3nDashboard.compatibilityLayout = compatibilityLayout;
  return Tok3nDashboard.resizeContent = resizeContent;
})();
