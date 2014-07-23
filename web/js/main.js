(function() {

  /*
  Main
   */
  var destroyActiveWindowJs, destroyMasonry, destroyValidatedForms, executeIfExists, hasDOMContentLoaded, init, initCurrentWindow, main, observePageChanges, ready, readyMethod, toCamelCase;
  main = function() {
    Tok3nDashboard.Screens.sitewide();
    Tok3nDashboard.slider();
    ee.addListener('tok3nSlideBeforeAnimation', function() {
      return initCurrentWindow();
    });
    initCurrentWindow();
    querySelectorAll('.tok3n-main-content').forEach(function(el) {
      return observePageChanges(el);
    });
    if (Tok3nDashboard.Environment.isDevelopment) {
      window.addEventListener("keyup", function(event) {
        if (event.keyCode === 49) {
          return querySelectorAll('.tok3n-dashboard-alert').forEach(function(el) {
            return el.classList.toggle('tok3n-dashboard-alert-hidden');
          });
        }
      });
      window.addEventListener("keyup", function(event) {
        if (event.keyCode === 50) {
          return querySelectorAll('.tok3n-dashboard-alert').forEach(function(el) {
            el.classList.remove('tok3n-dashboard-alert-active');
            return setTimeout(function() {
              return el.classList.add('tok3n-dashboard-alert-active');
            }, 0);
          });
        }
      });
    }
  };

  /*
  Selective window behavior
   */
  destroyMasonry = function() {
    if (Tok3nDashboard.masonry) {
      if (Tok3nDashboard.masonry.isResizeBound) {
        Tok3nDashboard.masonry.destroy();
        if (Tok3nDashboard.Environment.isDevelopment) {
          return console.log('Destroyed masonry.');
        }
      }
    }
  };
  destroyValidatedForms = function() {
    if (Tok3nDashboard.ValidatedForms.length) {
      Tok3nDashboard.ValidatedForms.forEach(function(el) {
        el.parsley().destroy();
        if (Tok3nDashboard.Environment.isDevelopment) {
          if (el.attr('id')) {
            return console.log("Destroyed Validated form #" + (el.attr('id')));
          } else {
            return console.log('Destroyed validated form with no id.');
          }
        }
      });
      return Tok3nDashboard.ValidatedForms = [];
    }
  };
  destroyActiveWindowJs = function() {
    var currentWindow;
    currentWindow = function() {
      if (Tok3nDashboard.nextTarget !== void 0) {
        return Tok3nDashboard.nextTarget;
      } else {
        return document.querySelector('.tok3n-pt-page-current');
      }
    };
    destroyValidatedForms();
    return setTimeout(function() {
      if (currentWindow().id !== 'tok3nDevices') {
        false;
      }
      if (currentWindow().id !== 'tok3nPhonelines') {
        false;
      }
      if (currentWindow().id !== 'tok3nApplications') {
        destroyMasonry();
      }
      if (currentWindow().id !== 'tok3nIntegrations') {
        false;
      }
      if (currentWindow().id !== 'tok3nBackupCodes') {
        false;
      }
      if (currentWindow().id !== 'tok3nSettings') {
        return false;
      }
    }, 250);
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
  executeIfExists = function(arr) {
    return arr.forEach(function(screen) {
      if (document.querySelector(".tok3n-" + screen)) {
        if (Tok3nDashboard.Environment.isDevelopment) {
          console.log(toCamelCase(screen) + " is the current screen");
        }
        if (typeof Tok3nDashboard.Screens[toCamelCase(screen)] === 'function') {
          return Tok3nDashboard.Screens[toCamelCase(screen)]();
        }
      }
    });
  };
  initCurrentWindow = function() {
    var currentWindow;
    currentWindow = function() {
      if (Tok3nDashboard.nextTarget !== void 0) {
        return Tok3nDashboard.nextTarget;
      } else {
        return document.querySelector('.tok3n-pt-page-current');
      }
    };
    destroyActiveWindowJs();
    switch (currentWindow().id) {
      case "tok3nDevices":
        return executeIfExists(['devices', 'device-view', 'device-new-1', 'device-new-2', 'device-new-3']);
      case "tok3nPhonelines":
        return executeIfExists(['phonelines', 'phoneline-view-cellphone', 'phoneline-view-landline', 'phoneline-new-1', 'phoneline-new-2', 'phoneline-new-3']);
      case "tok3nApplications":
        return executeIfExists(['applications']);
      case "tok3nIntegrations":
        if (!Tok3nDashboard.Charts.areLoaded) {
          Tok3nDashboard.Screens.integrationsCharts();
        }
        return executeIfExists(['integrations', 'integration-view', 'integration-new', 'integration-edit']);
      case "tok3nBackupCodes":
        return executeIfExists(['backup-codes']);
      case "tok3nSettings":
        return executeIfExists(['settings']);
      default:
        return false;
    }
  };
  observePageChanges = function(el) {
    var observer;
    observer = new MutationObserver(function(mutations) {
      return mutations.forEach(function(mutation) {
        if (Tok3nDashboard.Environment.isDevelopment) {
          console.log("Partial screen change detected.");
        }
        false;
        return initCurrentWindow();
      });
    });
    return observer.observe(el, {
      childList: true
    });
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
