(function() {
  var lastLoader, loadingProtocol, polyfillsUrl;
  loadingProtocol = getLoadingProtocol();
  polyfillsUrl = Tok3nDashboard.cdnUrl + '/polyfills/min';
  if (location.protocol !== "file:") {
    Modernizr.load([
      {
        test: Modernizr.mq,
        nope: polyfillsUrl + '/respond.min.js'
      }, {
        test: document.documentElement.classList,
        nope: polyfillsUrl + '/classList.min.js'
      }, {
        test: document.querySelector,
        nope: polyfillsUrl + '/querySelector.polyfill.js'
      }, {
        test: Modernizr.csscalc,
        nope: polyfillsUrl + '/calc.min.js'
      }, {
        test: Modernizr.extrinsicsizing,
        nope: Tok3nDashboard.cdnUrl + '/compatibility.js',
        callback: function() {
          if (Tok3nDashboard.compatibilityLayout) {
            return Tok3nDashboard.compatibilityLayout();
          }
        }
      }, {
        test: String.prototype.contains,
        nope: function() {
          return String.prototype.contains = function() {
            return String.prototype.indexOf.apply(this, arguments) !== -1;
          };
        }
      }, {
        test: Array.prototype.some,
        nope: polyfillsUrl + '/array.some.js'
      }, {
        test: Array.prototype.filter,
        nope: polyfillsUrl + '/array.filter.js'
      }, {
        test: window.MutationObserver,
        nope: polyfillsUrl + '/MutationObserver.js'
      }, {
        test: window.Promise,
        nope: polyfillsUrl + '/promise-1.0.0.min.js'
      }, {
        test: window.CustomEvent,
        nope: polyfillsUrl + '/customevent.js'
      }
    ]);
  }
  lastLoader = function() {
    Modernizr.load([
      {
        load: "" + loadingProtocol + "//www.google.com/jsapi",
        complete: function() {
          Tok3nDashboard.Jsapi.isLoaded = new Promise(function(resolve, reject) {
            return google.load("visualization", "1", {
              packages: ["corechart"],
              callback: function() {
                return resolve();
              }
            });
          });
          return ee.emitEvent('tok3nJsapiPromiseCreated');
        }
      }
    ]);
    if (location.protocol !== "file:") {
      Modernizr.load([
        {
          load: "//use.typekit.net/" + Tok3nDashboard.typekit + ".js",
          complete: function() {
            try {
              Typekit.load();
            } catch (_error) {}
          }
        }
      ]);
      if (!Tok3nDashboard.Environment.isDevelopment) {
        return Modernizr.load([
          {
            load: ("https:" === location.protocol ? "//ssl" : "//www") + ".google-analytics.com/ga.js"
          }
        ]);
      }
    }
  };
  return Tok3nDashboard.lastLoader = lastLoader;
})();
