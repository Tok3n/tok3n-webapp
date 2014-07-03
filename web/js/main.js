var contentHeight, each, gebi, getStyle, hasDOMContentLoaded, indexOf, init, main, qs, qsa, querySelectorAll, ready, readyMethod, resizeContent, root, slice, windowHeight;

each = Function.prototype.call.bind([].forEach);

indexOf = Function.prototype.call.bind([].indexOf);

slice = Function.prototype.call.bind([].slice);

qs = document.querySelector.bind(document);

qsa = document.querySelectorAll.bind(document);

gebi = document.getElementById.bind(document);

querySelectorAll = function(selector) {
  return slice(document.querySelectorAll(selector));
};

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

getStyle = function(oElm, strCssRule) {
  var strValue;
  strValue = "";
  if (document.defaultView && document.defaultView.getComputedStyle) {
    strValue = document.defaultView.getComputedStyle(oElm, "").getPropertyValue(strCssRule);
  } else if (oElm.currentStyle) {
    strCssRule = strCssRule.replace(/\-(\w)/g, function(strMatch, p1) {
      return p1.toUpperCase();
    });
    strValue = oElm.currentStyle[strCssRule];
  }
  return strValue;
};

windowHeight = function() {
  var $topHeight;
  $topHeight = null;
  if (window.matchMedia("(min-width: 769px)").matches) {
    $topHeight = parseInt(getStyle(document.querySelector('#tok3nLayout'), 'padding-top'), 10);
  } else {
    $topHeight = parseInt(getStyle(document.querySelector('#tok3nTop'), 'height'), 10);
  }
  return window.innerHeight - $topHeight;
};

contentHeight = function() {
  var $contentHeight, elemList, innerContentHeight, listHeight;
  $contentHeight = null;
  innerContentHeight = parseInt(getStyle(document.querySelector('.tok3n-pt-page-current .tok3n-main-content'), 'height'), 10);
  elemList = document.querySelector('.tok3n-pt-page-current .tok3n-main-list');
  if (elemList != null) {
    listHeight = parseInt(getStyle(elemList, 'height'), 10);
  } else {
    listHeight = 0;
  }
  if (window.matchMedia("(min-width: 769px)").matches) {
    $contentHeight = innerContentHeight;
  } else {
    $contentHeight = innerContentHeight + listHeight;
  }
  return $contentHeight;
};

resizeContent = function() {
  var $contentHeight, $topHeight, $windowHeight, currentContent, el, _i, _j, _len, _len1;
  currentContent = document.querySelectorAll('.tok3n-pt-perspective, .tok3n-pt-page-current');
  $windowHeight = windowHeight();
  $contentHeight = contentHeight();
  $topHeight = parseInt(getStyle(document.querySelector('#tok3nTop'), 'height'), 10);
  if ($windowHeight > $contentHeight) {
    for (_i = 0, _len = currentContent.length; _i < _len; _i++) {
      el = currentContent[_i];
      el.style.height = $windowHeight + "px";
    }
  } else {
    for (_j = 0, _len1 = currentContent.length; _j < _len1; _j++) {
      el = currentContent[_j];
      el.style.height = $contentHeight + "px";
    }
  }
};

window.addEventListener("resize", function(event) {
  resizeContent();
});

main = function() {
  (function(el) {
    var WidthChange, menuItems, mq;
    if (el) {
      document.querySelector('#collapseSidebarButton').addEventListener('click', function() {
        return el.classList.toggle('collapsed');
      }, false);
      menuItems = querySelectorAll('.tok3n-menu-item');
      menuItems.forEach(function(item) {
        return item.addEventListener('click', function() {
          if (window.matchMedia("(max-width: 768px)").matches) {
            return el.classList.toggle('collapsed');
          }
        }, false);
      });
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
  })(document.querySelector('#tok3nSidebarMenu'));
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
  })(document.querySelector('.tok3n-cards-container'));
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
