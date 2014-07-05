

(function() {

  /*
  Sliding login window
   */
  var animationClasses, removeAnimationClasses, slider;
  animationClasses = ['tok3n-move-from-left', 'tok3n-move-to-left', 'tok3n-move-from-right', 'tok3n-move-to-right'];
  removeAnimationClasses = function(el) {
    return each(animationClasses, function(cl) {
      return el.classList.remove(cl);
    });
  };
  slider = function() {
    var menuItemAnchorClass, menuItemSelectedClass, options, previousOption, previousTarget, previousTargetId;
    options = querySelectorAll("#tok3nSidebarMenu li");
    menuItemAnchorClass = "tok3n-menu-item";
    menuItemSelectedClass = "tok3n-sidebar-selected";
    previousOption = qs("#tok3nSidebarMenu li." + menuItemSelectedClass);
    previousTargetId = previousOption.getAttribute("data-target").toString();
    previousTarget = gebi(previousTargetId);
    options.forEach(function(el) {
      el.addEventListener("click", function(evt) {
        var animationSlide, nextOption, nextTarget, nextTargetId, temp;
        nextOption = evt.target.classList.contains(menuItemAnchorClass) ? evt.target : findClosestAncestor(evt.target, menuItemAnchorClass);
        if (previousOption !== nextOption) {
          previousOption.classList.remove(menuItemSelectedClass);
          nextOption.classList.add(menuItemSelectedClass);
        }
        nextTargetId = nextOption.getAttribute("data-target").toString();
        nextTarget = gebi(nextTargetId);
        temp = void 0;
        animationSlide = function(option) {
          if (option !== "previous" && option !== "next") {
            return;
          }
          if (childNodeIndex(nextOption) < childNodeIndex(previousOption)) {
            if (option === "previous") {
              return "left";
            } else {
              return "right";
            }
          } else if (childNodeIndex(nextOption) > childNodeIndex(previousOption)) {
            if (option === "previous") {
              return "right";
            } else {
              return "left";
            }
          } else {
            return false;
          }
        };
        if (childNodeIndex(nextOption) !== childNodeIndex(previousOption)) {
          removeAnimationClasses(previousTarget);
          Tok3nDashboard.nextTarget = nextTarget;
          Tok3nDashboard.previousTarget = previousTarget;
          ee.emitEvent('tok3nSlideBeforeAnimation');
          previousTarget.classList.add("tok3n-move-to-" + (animationSlide('previous')));
          temp = previousTarget;
          setTimeout(function() {
            temp.classList.remove("tok3n-pt-page-previous");
            temp.classList.remove("tok3n-pt-page-current");
            return ee.emitEvent('tok3nSlideAfterAnimation');
          }, 250);
          removeAnimationClasses(nextTarget);
          nextTarget.classList.add("tok3n-pt-page-current");
          nextTarget.classList.add("tok3n-move-from-" + (animationSlide('next')));
        }
        previousOption = nextOption;
        previousTargetId = previousOption.getAttribute("data-target").toString();
        return previousTarget = gebi(previousTargetId);
      });
    });
  };
  return Tok3nDashboard.slider = slider;
})();

(function() {

  /*
  Main
   */
  var authorizedApps, camelCaseSwitcher, destroyActiveWindowJs, hasDOMContentLoaded, init, initCurrentWindow, main, ready, readyMethod, sitewide, toggleSecret;
  main = function() {
    sitewide();
    Tok3nDashboard.slider();
    ee.addListener('tok3nSlideBeforeAnimation', function() {
      return initCurrentWindow();
    });
  };

  /*
  Sitewide
   */
  sitewide = function() {
    (function(el) {
      var WidthChange, menuItems, mq;
      if (el) {
        document.querySelector('#collapseSidebarButton').addEventListener('click', function() {
          return el.classList.toggle('collapsed');
        }, false);
        menuItems = querySelectorAll('.tok3n-menu-item');
        menuItems.forEach(function(item) {
          return item.addEventListener('click', function() {
            if (window.matchMedia("(max-width: 768px)").matches) {
              return el.classList.toggle('collapsed');
            }
          }, false);
        });
        WidthChange = function(mq) {
          if (mq.matches) {
            if (el.classList.contains('collapsed')) {
              el.classList.remove('collapsed');
            }
          } else {
            if (!el.classList.contains('collapsed')) {
              el.classList.add('collapsed');
            }
          }
        };
        if (matchMedia) {
          mq = window.matchMedia("(min-width: 769px)");
          mq.addListener(WidthChange);
          return WidthChange(mq);
        }
      }
    })(document.querySelector('#tok3nSidebarMenu'));
    return (function(arr) {
      var el, _i, _len, _results;
      if (arr) {
        _results = [];
        for (_i = 0, _len = arr.length; _i < _len; _i++) {
          el = arr[_i];
          _results.push(el.addEventListener('click', function() {
            var child, _j, _len1, _ref, _results1;
            _ref = el.children;
            _results1 = [];
            for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
              child = _ref[_j];
              if (child.classList.contains('dropdown-menu')) {
                _results1.push(child.classList.toggle('dropdown-show'));
              } else {
                _results1.push(void 0);
              }
            }
            return _results1;
          }, false));
        }
        return _results;
      }
    })(document.querySelectorAll('.dropdown'));
  };

  /*
  Selective window behavior
   */
  destroyActiveWindowJs = function() {
    var currentWindow;
    currentWindow = Tok3nDashboard.nextTarget;
    return setTimeout(function() {
      if (currentWindow.id !== 'tok3nDevices') {
        false;
      }
      if (currentWindow.id !== 'tok3nPhonelines') {
        false;
      }
      if (currentWindow.id !== 'tok3nApplications') {
        if (Tok3nDashboard.masonry != null) {
          Tok3nDashboard.masonry.destroy();
        }
      }
      if (currentWindow.id !== 'tok3nIntegrations') {
        false;
      }
      if (currentWindow.id !== 'tok3nBackupCodes') {
        false;
      }
      if (currentWindow.id !== 'tok3nBackupSettings') {
        return false;
      }
    }, 250);
  };
  camelCaseSwitcher = function(arr, func) {
    return arr.forEach(function(screen) {
      var screenClass;
      screenClass = ".tok3n-" + screen.replace(/([a-z])([A-Z])/g, '$1-$2').replace(/([a-zA-Z]+)([0-9]+)/g, '$1-$2').toLowerCase();
      return func(screen);
    });
  };
  initCurrentWindow = function() {
    var currentWindow, signupScreens;
    currentWindow = Tok3nDashboard.nextTarget;
    destroyActiveWindowJs();
    switch (currentWindow.id) {
      case "tok3n-signup":
        signupScreens = ['signupEnable', 'signupCreate1', 'signupCreate2', 'signupDevice1', 'signupDevice2', 'signupPhoneline1', 'signupPhoneline2'];
        return camelCaseSwitcher(signupScreens, function(currentWindow) {
          switch (currentWindow) {
            case 'signupEnable':
              return false;
            case 'signupCreate1':
              return false;
            case 'signupCreate2':
              return false;
            case 'signupPhoneline1':
              return false;
            case 'signupPhoneline2':
              return false;
            default:
              return false;
          }
        });
      case "tok3ndDevices":
        return false;
      case "tok3nPhonelines":
        return false;
      case "tok3nApplications":
        return authorizedApps();
      case "tok3nIntegrations":
        return toggleSecret();
      case "tok3nBackupCodes":
        return false;
      case "tok3nSettings":
        return false;
      default:
        return false;
    }
  };

  /*
  Authorized apps
   */
  authorizedApps = function() {
    var cardsContainer;
    cardsContainer = qs('.tok3n-cards-container');
    if (cardsContainer) {
      Tok3nDashboard.masonry = new Masonry(cardsContainer, {
        itemSelector: '.card',
        gutter: '.grid-gutter'
      });
    }
    forEach(cardsContainer.querySelectorAll('.front'), function(el) {
      return el.addEventListener('click', function() {
        var card;
        findClosestAncestor(el, 'flipper').classList.add('flipped');
        card = [].filter.call(el.parentNode.children, function(gl) {
          return gl.classList.contains('back');
        });
        return forEach(card, function(fl) {
          return fl.style.zIndex = 3;
        });
      }, false);
    });
    return forEach(cardsContainer.querySelectorAll('.flip'), function(el) {
      return el.addEventListener('click', function() {
        return findClosestAncestor(el, 'flipper').classList.remove('flipped');
      }, false);
    });
  };

  /*
  My integrations
   */
  toggleSecret = function() {
    var toggleEl;
    toggleEl = qsa('.toggle-secret');
    if (toggleEl != null) {
      return forEach(toggleEl, function(el) {
        return el.addEventListener('click', function() {
          var hiddenEl;
          hiddenEl = [].filter.call(el.parentNode.children, function(gl) {
            return gl.classList.contains('secret');
          });
          if (hiddenEl != null) {
            return forEach(hiddenEl, function(fl) {
              return fl.classList.toggle('hidden');
            });
          }
        }, false);
      });
    }
  };

  /*
  Vanilla $('document').ready() detection. Execute main() when it is.
   */
  hasDOMContentLoaded = false;
  ready = false;
  readyMethod = null;
  init = function(method) {
    if (!ready) {
      ready = true;
      readyMethod = method;
      main();
    }
  };
  document.addEventListener("DOMContentLoaded", function(event) {
    hasDOMContentLoaded = true;
    init("DOMContentLoaded");
  });
  document.onreadystatechange = function() {
    init("onreadystatechange");
  };
  return document.addEventListener("load", function(event) {
    init("load");
  });
})();
