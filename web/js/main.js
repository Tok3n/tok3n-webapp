(function() {

  /*
  Main
   */
  var compatibilityObserver, currentWindow, destroyPrevious, hasDOMContentLoaded, init, initCurrentWindow, initIfExists, main, observePageChanges, ready, readyMethod, switchWindow, testAlerts, testFormEvents, toCamelCase, toTok3nCssClass;
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
      var currentScreen, funcName;
      currentScreen = document.querySelector(".tok3n-" + screen);
      if (currentScreen) {
        funcName = toCamelCase(screen);
        if (typeof Tok3nDashboard.Screens[funcName] === 'function') {
          Tok3nDashboard.CurrentScreens.push(currentScreen);
          devConsoleLog("Inited " + funcName);
          return Tok3nDashboard.Screens[funcName]();
        }
      }
    });
  };
  destroyPrevious = function() {
    return setTimeout(function() {
      if (Tok3nDashboard.PreviousScreens.length) {
        Tok3nDashboard.PreviousScreens.forEach(function(screen) {
          var commonName, destroyName, screenKind;
          commonName = void 0;
          screenKind = void 0;
          if (!screen.id.indexOf('tok3n' === -1)) {
            commonName = lowercaseFirstLetter(screen.id.replace('tok3n', ''));
            screenKind = 'main page';
          } else {
            commonName = toCamelCase(screen.classList[0].replace('tok3n-', ''));
            screenKind = 'partial';
          }
          destroyName = 'destroy' + capitaliseFirstLetter(commonName);
          if (typeof Tok3nDashboard.Screens[destroyName] === 'function') {
            Tok3nDashboard.Screens[destroyName]();
            return devConsoleLog("Destroyed " + screenKind + " " + commonName);
          }
        });
      }
      Tok3nDashboard.PreviousScreens = Tok3nDashboard.CurrentScreens;
      return Tok3nDashboard.CurrentScreens = [];
    }, Tok3nDashboard.slidingAnimationDuration);
  };
  switchWindow = function() {
    switch (currentWindow().id) {
      case "tok3nDevices":
        return initIfExists(['devices', 'device-view', 'device-new-1', 'device-new-2', 'device-new-3']);
      case "tok3nPhonelines":
        return initIfExists(['phonelines', 'phoneline-view-cellphone', 'phoneline-view-landline', 'phoneline-new-1', 'phoneline-new-2', 'phoneline-new-3']);
      case "tok3nApplications":
        return initIfExists(['applications']);
      case "tok3nIntegrations":
        if (!Tok3nDashboard.Charts.areLoaded) {
          Tok3nDashboard.Screens.integrationsCharts();
        }
        return initIfExists(['integrations', 'integration-view', 'integration-new', 'integration-edit']);
      case "tok3nBackupCodes":
        return initIfExists(['backup-codes']);
      case "tok3nSettings":
        return initIfExists(['settings']);
      default:
        return false;
    }
  };
  initCurrentWindow = function() {
    Tok3nDashboard.Screens.initEveryTime();
    switchWindow();
    destroyPrevious();
    return Tok3nDashboard.Screens.destroyEveryTime();
  };
  observePageChanges = function(el) {
    var observer;
    observer = new MutationObserver(function(mutations) {
      return mutations.forEach(function(mutation) {
        devConsoleLog("Partial screen change detected.");
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
        devConsoleLog("Partial screen change detected.");
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
