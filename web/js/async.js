var root;

root = typeof exports !== "undefined" && exports !== null ? exports : this;

root._gaq = [['_setAccount', 'UA-39917560-2'], ['_trackPageview']];

Modernizr.addTest("csscalc", function() {
  var el, prop, value;
  prop = "width:";
  value = "calc(10px);";
  el = document.createElement("div");
  el.style.cssText = prop + Modernizr._prefixes.join(value + prop);
  return !!el.style.length;
});

Modernizr.load([
  {
    test: Modernizr.mq,
    nope: 'https://raw.githubusercontent.com/scottjehl/Respond/master/dest/respond.min.js'
  }, {
    test: document.documentElement.classList,
    nope: 'https://raw.githubusercontent.com/eligrey/classList.js/master/classList.min.js'
  }, {
    test: Modernizr.flexbox && Modernizr.csscalc,
    nope: function() {
      return Tok3nDashboard.compatibilityLayout();
    }
  }, {
    load: ("https:" === location.protocol ? "//ssl" : "//www") + ".google-analytics.com/ga.js"
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
    load: "//use.typekit.net/nls8ikc.js",
    complete: function() {
      try {
        Typekit.load();
      } catch (_error) {}
    }
  }
]);
