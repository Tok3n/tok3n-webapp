(function() {
  return Modernizr.load([
    {
      test: Modernizr.mq,
      nope: 'https://raw.githubusercontent.com/scottjehl/Respond/master/dest/respond.min.js'
    }, {
      test: document.documentElement.classList,
      nope: 'https://raw.githubusercontent.com/eligrey/classList.js/master/classList.min.js'
    }, {
      test: document.querySelector,
      nope: 'https://gist.githubusercontent.com/chrisjlee/8960575/raw/53c2a101030437f02fe774f43733673f99a13a0a/querySelector.polyfill.js'
    }, {
      test: CSS.supports,
      nope: 'https://raw.githubusercontent.com/termi/CSS.supports/master/__COMPILED/CSS.supports.js'
    }, {
      test: CSS.supports('width', 'calc(10px)') || CSS.supports('width', '-webkit-calc(10px)') || CSS.supports('width', '-moz-calc(10px)'),
      nope: 'https://raw.githubusercontent.com/closingtag/calc-polyfill/master/calc.min.js'
    }, {
      test: CSS.supports('min-height', '-webkit-fill-available') || CSS.supports('min-height', '-moz-available'),
      nope: function() {
        Tok3nDashboard.compatibilityLayout();
        return window.setInterval(function() {
          return Tok3nDashboard.resizeContent();
        }, 1000);
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
      nope: function() {
        return Array.prototype.some = function(fun, thisArg) {
          "use strict";
          var i, len, t;
          if (this === void 0 || this === null) {
            throw new TypeError();
          }
          t = Object(this);
          len = t.length >>> 0;
          if (typeof fun !== "function") {
            throw new TypeError();
          }
          thisArg = arguments.length >= 2 ? arguments[1] : void 0;
          i = 0;
          while (i < len) {
            if (i in t && fun.call(thisArg, t[i], i, t)) {
              return true;
            }
            i++;
          }
          return false;
        };
      }
    }, {
      test: Array.prototype.filter,
      nope: function() {
        return Array.prototype.filter = function(fun) {
          "use strict";
          var i, len, res, t, thisArg, val;
          if (this === void 0 || this === null) {
            throw new TypeError();
          }
          t = Object(this);
          len = t.length >>> 0;
          if (typeof fun !== "function") {
            throw new TypeError();
          }
          res = [];
          thisArg = (arguments_.length >= 2 ? arguments_[1] : void 0);
          i = 0;
          while (i < len) {
            if (i in t) {
              val = t[i];
              if (fun.call(thisArg, val, i, t)) {
                res.push(val);
              }
            }
            i++;
          }
          return res;
        };
      }
    }, {
      test: window.MutationObserver,
      nope: "https://raw.githubusercontent.com/Polymer/MutationObservers/master/MutationObserver.js"
    }, {
      test: window.Promise,
      nope: 'http://s3.amazonaws.com/es6-promises/promise-1.0.0.min.js'
    }, {
      test: window.CustomEvent,
      nope: function() {
        var CustomEvent;
        CustomEvent = function(event, params) {
          var evt;
          params = params || {
            bubbles: false,
            cancelable: false,
            detail: void 0
          };
          evt = document.createEvent("CustomEvent");
          evt.initCustomEvent(event, params.bubbles, params.cancelable, params.detail);
          return evt;
        };
        CustomEvent.prototype = window.Event.prototype;
        window.CustomEvent = CustomEvent;
      }
    }, {
      load: "//use.typekit.net/" + Tok3nDashboard.typekit + ".js",
      complete: function() {
        try {
          Typekit.load();
        } catch (_error) {}
      }
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
