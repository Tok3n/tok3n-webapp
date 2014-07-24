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
            Tok3nDashboard.tempPreviousTarget = temp;
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
  var compatibilityObserver, currentWindow, destroyCurrentIfExists, hasDOMContentLoaded, init, initCurrentWindow, initIfExists, main, observePageChanges, ready, readyMethod, testAlerts, testFormEvents, toCamelCase, toTok3nCssClass;
  main = function() {
    Tok3nDashboard.Screens.sitewide();
    Tok3nDashboard.slider();
    ee.addListener('tok3nSlideBeforeAnimation', function() {
      return initCurrentWindow();
    });
    initCurrentWindow();
    querySelectorAll('.tok3n-main-content').forEach(function(el) {
      if (Tok3nDashboard.compatibilityLayout) {
        return compatibilityObserver(el);
      } else {
        return observePageChanges(el);
      }
    });
    ee.addListener('tok3nSlideAfterAnimation', function() {
      return false;
    });
    Tok3nDashboard.lastLoader();
    if (Tok3nDashboard.Environment.isDevelopment) {
      testAlerts();
      return testFormEvents();
    }
  };

  /*
  Selective window behavior
   */
  currentWindow = function() {
    if (Tok3nDashboard.nextTarget !== void 0) {
      return Tok3nDashboard.nextTarget;
    } else {
      return document.querySelector('.tok3n-pt-page-current');
    }
  };
  toCamelCase = function(s) {
    s = s.replace(/([^a-zA-Z0-9_\- ])|^[_0-9]+/g, "").trim().toLowerCase();
    s = s.replace(/([ -]+)([a-zA-Z0-9])/g, function(a, b, c) {
      return c.toUpperCase();
    });
    s = s.replace(/([0-9]+)([a-zA-Z])/g, function(a, b, c) {
      return b + c.toUpperCase();
    });
    return s;
  };
  toTok3nCssClass = function(camel) {
    return "tok3n-" + camel.replace(/([a-z])([A-Z])/g, '$1-$2').replace(/([a-zA-Z]+)([0-9]+)/g, '$1-$2').toLowerCase();
  };
  initIfExists = function(arr) {
    return arr.forEach(function(screen) {
      var currentScreen;
      currentScreen = document.querySelector(".tok3n-" + screen);
      if (currentScreen) {
        if (typeof Tok3nDashboard.Screens[toCamelCase(screen)] === 'function') {
          Tok3nDashboard.CurrentScreens.push(currentScreen);
          Tok3nDashboard.Screens[toCamelCase(screen)]();
        }
        if (Tok3nDashboard.Environment.isDevelopment) {
          return console.log(toCamelCase(screen) + " is the current screen.");
        }
      }
    });
  };
  destroyCurrentIfExists = function() {
    Tok3nDashboard.CurrentScreens.forEach(function(screen) {
      var destroyName;
      destroyName = function() {
        if (screen.id.indexOf('tok3n' !== -1)) {
          return lowercaseFirstLetter(screen.id.replace('tok3n', ''));
        } else {
          return toCamelCase(screen.classList[0].replace('tok3n-', ''));
        }
      };
      if (typeof Tok3nDashboard.Screens[destroyName()] === 'function') {
        Tok3nDashboard.Screens['destroy' + capitaliseFirstLetter(destroyName())]();
        if (Tok3nDashboard.Environment.isDevelopment) {
          return console.log("Destroyed " + (destroyName()));
        }
      }
    });
    return Tok3nDashboard.CurrentScreens = [];
  };
  initCurrentWindow = function() {
    currentWindow = function() {
      if (Tok3nDashboard.nextTarget !== void 0) {
        return Tok3nDashboard.nextTarget;
      } else {
        return document.querySelector('.tok3n-pt-page-current');
      }
    };
    if (Tok3nDashboard.Environment.isDevelopment) {
      console.log('Started initing js.');
    }
    destroyCurrentIfExists();
    switch (currentWindow().id) {
      case "tok3nDevices":
        initIfExists(['devices', 'device-view', 'device-new-1', 'device-new-2', 'device-new-3']);
        break;
      case "tok3nPhonelines":
        initIfExists(['phonelines', 'phoneline-view-cellphone', 'phoneline-view-landline', 'phoneline-new-1', 'phoneline-new-2', 'phoneline-new-3']);
        break;
      case "tok3nApplications":
        initIfExists(['applications']);
        break;
      case "tok3nIntegrations":
        if (!Tok3nDashboard.Charts.areLoaded) {
          Tok3nDashboard.Screens.integrationsCharts();
        }
        initIfExists(['integrations', 'integration-view', 'integration-new', 'integration-edit']);
        break;
      case "tok3nBackupCodes":
        initIfExists(['backup-codes']);
        break;
      case "tok3nSettings":
        initIfExists(['settings']);
        break;
      default:
        false;
    }
    if (Tok3nDashboard.Environment.isDevelopment) {
      return console.log('Finished initing js.');
    }
  };
  observePageChanges = function(el) {
    var observer;
    observer = new MutationObserver(function(mutations) {
      return mutations.forEach(function(mutation) {
        if (Tok3nDashboard.Environment.isDevelopment) {
          console.log("Partial screen change detected.");
        }
        return initCurrentWindow();
      });
    });
    return observer.observe(el, {
      childList: true
    });
  };
  compatibilityObserver = function(el) {
    var observer;
    observer = new MutationObserver(function(mutations) {
      return mutations.forEach(function(mutation) {
        if (Tok3nDashboard.Environment.isDevelopment) {
          console.log("Partial screen change detected.");
        }
        destroyCurrentIfExists();
        return Tok3nDashboard.resizeContent();
      });
    });
    return observer.observe(el, {
      childList: true,
      subtree: true
    });
  };

  /*
  Testing functions
   */
  testAlerts = function() {
    window.addEventListener("keyup", function(event) {
      if (event.keyCode === 49) {
        return querySelectorAll('.tok3n-dashboard-alert').forEach(function(el) {
          return el.classList.toggle('tok3n-dashboard-alert-hidden');
        });
      }
    });
    return window.addEventListener("keyup", function(event) {
      if (event.keyCode === 50) {
        return querySelectorAll('.tok3n-dashboard-alert').forEach(function(el) {
          el.classList.remove('tok3n-dashboard-alert-active');
          return setTimeout(function() {
            return el.classList.add('tok3n-dashboard-alert-active');
          }, 0);
        });
      }
    });
  };
  testFormEvents = function() {
    return window.addEventListener('submitValidatedForm', function(evt) {
      return console.log(evt);
    }, false);
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
