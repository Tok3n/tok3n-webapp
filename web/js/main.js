(function() {

  /*
  Main
   */
  var destroyActiveWindowJs, executeIfExists, hasDOMContentLoaded, init, initCurrentWindow, main, ready, readyMethod, toCamelCase;
  main = function() {
    Tok3nDashboard.Screens.sitewide();
    Tok3nDashboard.slider();
    ee.addListener('tok3nSlideBeforeAnimation', function() {
      return initCurrentWindow();
    });
    initCurrentWindow();
  };

  /*
  Selective window behavior
   */
  destroyActiveWindowJs = function() {
    var currentWindow;
    currentWindow = function() {
      if (Tok3nDashboard.nextTarget !== void 0) {
        return Tok3nDashboard.nextTarget;
      } else {
        return document.querySelector('.tok3n-pt-page-current');
      }
    };
    return setTimeout(function() {
      if (currentWindow().id !== 'tok3nDevices') {
        false;
      }
      if (currentWindow().id !== 'tok3nPhonelines') {
        false;
      }
      if (currentWindow().id !== 'tok3nApplications') {
        if (Tok3nDashboard.masonry != null) {
          Tok3nDashboard.masonry.destroy();
        }
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
          console.log(toCamelCase(screen));
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
        return executeIfExists(['device-view', 'device-new-1', 'device-new-2', 'device-new-3']);
      case "tok3nPhonelines":
        return executeIfExists(['phoneline-view-cellphone', 'phoneline-view-landline', 'phoneline-new-1', 'phoneline-new-2', 'phoneline-new-3']);
      case "tok3nApplications":
        return Tok3nDashboard.Screens.applications();
      case "tok3nIntegrations":
        return executeIfExists(['integration-view', 'integration-new', 'integration-edit']);
      case "tok3nBackupCodes":
        return false;
      case "tok3nSettings":
        return Tok3nDashboard.Screens.settings();
      default:
        return false;
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
