(function() {
  var each, gebi, hasDOMContentLoaded, indexOf, init, main, qs, qsa, querySelectorAll, ready, readyMethod, slice;
  window.Tok3nDashboard || (window.Tok3nDashboard = {});
  each = Function.prototype.call.bind([].forEach);
  indexOf = Function.prototype.call.bind([].indexOf);
  slice = Function.prototype.call.bind([].slice);
  qs = document.querySelector.bind(document);
  qsa = document.querySelectorAll.bind(document);
  gebi = document.getElementById.bind(document);
  querySelectorAll = function(selector) {
    return slice(document.querySelectorAll(selector));
  };
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
    Tok3nDashboard.slider();
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
  return document.addEventListener("load", function(event) {
    init("load");
  });
})();


