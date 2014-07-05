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
      load: "//use.typekit.net/nls8ikc.js",
      complete: function() {
        try {
          Typekit.load();
        } catch (_error) {}
      }
    }, {
      load: "//www.google.com/jsapi",
      complete: function() {
        google.load("visualization", "1", {
          packages: ["corechart"],
          callback: function() {
            var drawChartDataDonut, drawChartDataRequestHistory, drawChartDataUsersHistory;
            drawChartDataDonut = function(e) {
              var chart, data, options;
              data = google.visualization.arrayToDataTable([["Task", "Requests"], ["Valid", e.detail.ValidRequests], ["Invalid", e.detail.InvalidRequests], ["Pending", e.detail.IssuedRequests]]);
              options = {
                title: "Request types",
                pieHole: 0.4
              };
              chart = new google.visualization.PieChart(document.getElementById("donutChart"));
              chart.draw(data, options);
              return google.visualization.events.addListener(chart, "ready", function() {
                return resizeContent();
              });
            };
            drawChartDataRequestHistory = function(e) {
              var chart, data, options;
              data = google.visualization.arrayToDataTable(eval_(e.detail));
              console.log(data);
              options = {
                title: "Requests"
              };
              chart = new google.visualization.LineChart(document.getElementById("requestHistoryChart"));
              chart.draw(data, options);
              return google.visualization.events.addListener(chart, "ready", function() {
                return resizeContent();
              });
            };
            drawChartDataUsersHistory = function(e) {
              var chart, data, options;
              data = google.visualization.arrayToDataTable(eval_(e.detail));
              console.log(data);
              options = {
                title: "Users"
              };
              chart = new google.visualization.LineChart(document.getElementById("usersHistoryChart"));
              chart.draw(data, options);
              return google.visualization.events.addListener(chart, "ready", function() {
                return resizeContent();
              });
            };
            window.addEventListener("drawChartDataDonut", drawChartDataDonut, false);
            window.addEventListener("drawChartDataRequestHistory", drawChartDataRequestHistory, false);
            window.addEventListener("drawChartDataUsersHistory", drawChartDataUsersHistory, false);
          }
        });
      }
    }, {
      load: ("https:" === location.protocol ? "//ssl" : "//www") + ".google-analytics.com/ga.js"
    }
  ]);
})();
