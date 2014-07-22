

(function() {

  /*
  Sliding login window
   */
  var animationClasses, removeAnimationClasses, slider;
  animationClasses = ['tok3n-move-from-left', 'tok3n-move-to-left', 'tok3n-move-from-right', 'tok3n-move-to-right'];
  removeAnimationClasses = function(el) {
    return each(animationClasses, function(cl) {
      return el.classList.remove(cl);
    });
  };
  slider = function() {
    var menuItemAnchorClass, menuItemSelectedClass, options, previousOption, previousTarget, previousTargetId;
    options = querySelectorAll("#tok3nSidebarMenu li");
    menuItemAnchorClass = "tok3n-menu-item";
    menuItemSelectedClass = "tok3n-sidebar-selected";
    previousOption = qs("#tok3nSidebarMenu li." + menuItemSelectedClass);
    previousTargetId = previousOption.getAttribute("data-target").toString();
    previousTarget = gebi(previousTargetId);
    options.forEach(function(el) {
      el.addEventListener("click", function(evt) {
        var animationSlide, nextOption, nextTarget, nextTargetId, temp;
        nextOption = evt.target.classList.contains(menuItemAnchorClass) ? evt.target : findClosestAncestor(evt.target, menuItemAnchorClass);
        if (previousOption !== nextOption) {
          previousOption.classList.remove(menuItemSelectedClass);
          nextOption.classList.add(menuItemSelectedClass);
        }
        nextTargetId = nextOption.getAttribute("data-target").toString();
        nextTarget = gebi(nextTargetId);
        temp = void 0;
        animationSlide = function(option) {
          if (option !== "previous" && option !== "next") {
            return;
          }
          if (childNodeIndex(nextOption) < childNodeIndex(previousOption)) {
            if (option === "previous") {
              return "left";
            } else {
              return "right";
            }
          } else if (childNodeIndex(nextOption) > childNodeIndex(previousOption)) {
            if (option === "previous") {
              return "right";
            } else {
              return "left";
            }
          } else {
            return false;
          }
        };
        if (childNodeIndex(nextOption) !== childNodeIndex(previousOption)) {
          removeAnimationClasses(previousTarget);
          Tok3nDashboard.nextTarget = nextTarget;
          Tok3nDashboard.previousTarget = previousTarget;
          ee.emitEvent('tok3nSlideBeforeAnimation');
          previousTarget.classList.add("tok3n-move-to-" + (animationSlide('previous')));
          temp = previousTarget;
          setTimeout(function() {
            temp.classList.remove("tok3n-pt-page-previous");
            temp.classList.remove("tok3n-pt-page-current");
            return ee.emitEvent('tok3nSlideAfterAnimation');
          }, 250);
          removeAnimationClasses(nextTarget);
          nextTarget.classList.add("tok3n-pt-page-current");
          nextTarget.classList.add("tok3n-move-from-" + (animationSlide('next')));
        }
        previousOption = nextOption;
        previousTargetId = previousOption.getAttribute("data-target").toString();
        return previousTarget = gebi(previousTargetId);
      });
    });
  };
  return Tok3nDashboard.slider = slider;
})();

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
