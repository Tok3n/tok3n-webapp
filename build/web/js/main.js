var hasDOMContentLoaded, init, main, ready, readyMethod, root;

root = typeof exports !== "undefined" && exports !== null ? exports : this;

root._gaq = [['_setAccount', 'UA-39917560-2'], ['_trackPageview']];

Modernizr.load([
  {
    test: Modernizr.mq,
    nope: 'https://raw.githubusercontent.com/scottjehl/Respond/master/dest/respond.min.js'
  }, {
    test: document.documentElement.classList,
    nope: 'https://raw.githubusercontent.com/eligrey/classList.js/master/classList.min.js'
  }, {
    load: ("https:" === location.protocol ? "//ssl" : "//www") + ".google-analytics.com/ga.js"
  }, {
    load: "//www.google.com/jsapi",
    complete: function() {
      return google.load("visualization", "1", {
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
            return chart.draw(data, options);
          };
          drawChartDataRequestHistory = function(e) {
            var chart, data, options;
            data = google.visualization.arrayToDataTable(eval_(e.detail));
            console.log(data);
            options = {
              title: "Requests"
            };
            chart = new google.visualization.LineChart(document.getElementById("requestHistoryChart"));
            return chart.draw(data, options);
          };
          drawChartDataUsersHistory = function(e) {
            var chart, data, options;
            data = google.visualization.arrayToDataTable(eval_(e.detail));
            console.log(data);
            options = {
              title: "Users"
            };
            chart = new google.visualization.LineChart(document.getElementById("usersHistoryChart"));
            return chart.draw(data, options);
          };
          window.addEventListener("drawChartDataDonut", drawChartDataDonut, false);
          window.addEventListener("drawChartDataRequestHistory", drawChartDataRequestHistory, false);
          return window.addEventListener("drawChartDataUsersHistory", drawChartDataUsersHistory, false);
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

main = function() {
  (function(el) {
    var WidthChange, mq;
    if (el) {
      document.querySelector('#collapseSidebarButton').addEventListener('click', function() {
        return el.classList.toggle('collapsed');
      }, false);
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
  })(document.querySelector('#sidebarMenu'));
  (function(el) {
    var preventScrollPastElem;
    preventScrollPastElem = function(ev) {
      var WidthChange, mq;
      WidthChange = function(mq) {
        if (mq.matches) {
          ev.target.scrollTop -= ev.wheelDeltaY;
          ev.preventDefault();
        }
      };
      if (matchMedia) {
        mq = window.matchMedia("(min-width: 769px)");
        mq.addListener(WidthChange);
        WidthChange(mq);
      }
    };
    if (el) {
      return el.addEventListener('mousewheel', function(event) {
        return preventScrollPastElem(event);
      }, false);
    }
  })(document.querySelector('#list'));
  (function(arr) {
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
  (function(el) {
    var msnry;
    if (el) {
      return msnry = new Masonry(el, {
        itemSelector: '.card',
        gutter: '.grid-gutter'
      });
    }
  })(document.querySelector('#cards-container'));
};

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

document.addEventListener("load", function(event) {
  init("load");
});
