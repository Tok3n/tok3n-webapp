(function() {
  var authorizedApps, camelCaseSwitcher, destroyActiveWindowJs, hasDOMContentLoaded, init, initCurrentWindow, main, ready, readyMethod, sitewide;
  main = function() {
    sitewide();
    Tok3nDashboard.slider();
    ee.addListener('tok3nSlideBeforeAnimation', function() {
      return initCurrentWindow();
    });
  };
  sitewide = function() {
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
    return (function(arr) {
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
  };
  destroyActiveWindowJs = function() {
    var currentWindow;
    currentWindow = Tok3nDashboard.nextTarget;
    return setTimeout(function() {
      if (currentWindow.id !== 'tok3nDevices') {
        return false;
      } else if (currentWindow.id !== 'tok3nPhonelines') {
        return false;
      } else if (currentWindow.id !== 'tok3nApplications') {
        if (Tok3nDashboard.masonry) {
          return Tok3nDashboard.masonry.destroy();
        }
      } else if (currentWindow.id !== 'tok3nIntegrations') {
        return false;
      } else if (currentWindow.id !== 'tok3nBackupCodes') {
        return false;
      } else if (currentWindow.id !== 'tok3nBackupSettings') {
        return false;
      }
    }, 250);
  };
  camelCaseSwitcher = function(arr, func) {
    return arr.forEach(function(screen) {
      var screenClass;
      screenClass = ".tok3n-" + screen.replace(/([a-z])([A-Z])/g, '$1-$2').replace(/([a-zA-Z]+)([0-9]+)/g, '$1-$2').toLowerCase();
      return func(screen);
    });
  };
  initCurrentWindow = function() {
    var currentWindow, signupScreens;
    currentWindow = Tok3nDashboard.nextTarget;
    destroyActiveWindowJs();
    switch (currentWindow.id) {
      case "tok3n-signup":
        signupScreens = ['signupEnable', 'signupCreate1', 'signupCreate2', 'signupDevice1', 'signupDevice2', 'signupPhoneline1', 'signupPhoneline2'];
        return camelCaseSwitcher(signupScreens, function(currentWindow) {
          switch (currentWindow) {
            case 'signupEnable':
              return false;
            case 'signupCreate1':
              return false;
            case 'signupCreate2':
              return false;
            case 'signupPhoneline1':
              return false;
            case 'signupPhoneline2':
              return false;
            default:
              return false;
          }
        });
      case "tok3ndDevices":
        return false;
      case "tok3nPhonelines":
        return false;
      case "tok3nApplications":
        return authorizedApps();
      case "tok3nIntegrations":
        return false;
      case "tok3nBackupCodes":
        return false;
      case "tok3nSettings":
        return false;
      default:
        return false;
    }
  };
  authorizedApps = function() {
    return (function(el) {
      if (el) {
        return Tok3nDashboard.masonry = new Masonry(el, {
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
  return document.addEventListener("load", function(event) {
    init("load");
  });
})();


