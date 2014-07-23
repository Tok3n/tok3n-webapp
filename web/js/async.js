(function() {
  var polyfillsUrl;
  polyfillsUrl = Tok3nDashboard.cdnUrl + '/polyfills/min';
  return Modernizr.load([
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
      test: CSS.supports,
      nope: polyfillsUrl + '/CSS.supports.js'
    }, {
      test: CSS.supports('width', 'calc(10px)') || CSS.supports('width', '-webkit-calc(10px)') || CSS.supports('width', '-moz-calc(10px)'),
      nope: polyfillsUrl + '/calc.min.js'
    }, {
      test: CSS.supports('min-height', '-webkit-fill-available') || CSS.supports('min-height', '-moz-available'),
      nope: function() {
        Tok3nDashboard.compatibilityLayout();
        return window.setInterval(function() {
          return Tok3nDashboard.resizeContent();
        }, 1000);
      }
    }, {
      load: "//use.typekit.net/" + Tok3nDashboard.typekit + ".js",
      complete: function() {
        try {
          Typekit.load();
        } catch (_error) {}
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
    }, {
      load: "//www.google.com/jsapi",
      complete: function() {
        Tok3nDashboard.Jsapi.isLoaded = new Promise(function(resolve, reject) {
          return google.load("visualization", "1", {
            packages: ["corechart"],
            callback: function() {
              return resolve();
            }
          });
        });
        ee.emitEvent('tok3nJsapiPromiseCreated');
      }
    }, {
      load: ("https:" === location.protocol ? "//ssl" : "//www") + ".google-analytics.com/ga.js"
    }
  ]);
})();
