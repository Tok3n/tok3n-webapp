var capitaliseFirstLetter, childNodeIndex, closest, detectIE, devConsoleLog, each, ee, findClosestAncestor, forEach, functionName, gebi, hasFormValidation, indexOf, isEmptyOrDefault, lowercaseFirstLetter, namespace, namespaceExists, qs, qsa, querySelectorAll, root, slice,
  __slice = [].slice;

window.Tok3nDashboard || (window.Tok3nDashboard = {});

Tok3nDashboard.Environment || (Tok3nDashboard.Environment = {});

Tok3nDashboard.Jsapi || (Tok3nDashboard.Jsapi = {});

Tok3nDashboard.Charts || (Tok3nDashboard.Charts = {});

Tok3nDashboard.Screens || (Tok3nDashboard.Screens = {});

Tok3nDashboard.CurrentScreens || (Tok3nDashboard.CurrentScreens = []);

Tok3nDashboard.PreviousScreens || (Tok3nDashboard.PreviousScreens = []);

Tok3nDashboard.PreviousPreventedLinks || (Tok3nDashboard.PreviousPreventedLinks = []);

Tok3nDashboard.CurrentPreventedLinks || (Tok3nDashboard.CurrentPreventedLinks = []);

Tok3nDashboard.cdnUrl = '//s3.amazonaws.com/static.tok3n.com/tok3n-webapp';

Tok3nDashboard.initWindow || (Tok3nDashboard.initWindow = 'Devices');

Tok3nDashboard.slidingAnimationDuration = 250;

if (!Tok3nDashboard.Environment.isDevelopment) {
  Tok3nDashboard.Environment.isProduction = true;
} else {
  Tok3nDashboard.Environment.isProduction = false;
}

each = Function.prototype.call.bind([].forEach);

indexOf = Function.prototype.call.bind([].indexOf);

slice = Function.prototype.call.bind([].slice);

qs = document.querySelector.bind(document);

qsa = document.querySelectorAll.bind(document);

gebi = document.getElementById.bind(document);

querySelectorAll = function(selector) {
  return slice(document.querySelectorAll(selector));
};

forEach = function(list, callback) {
  Array.prototype.forEach.call(list, callback);
};

childNodeIndex = function(el) {
  return indexOf(el.parentNode.children, el);
};

findClosestAncestor = function(el, ancestorTag) {
  var parentEl;
  parentEl = el.parentElement;
  while (!parentEl.classList.contains(ancestorTag)) {
    parentEl = parentEl.parentElement;
  }
  return parentEl;
};

namespace = function(target, name, block) {
  var item, top, _i, _len, _ref, _ref1;
  if (arguments.length < 3) {
    _ref = [(typeof exports !== 'undefined' ? exports : window)].concat(__slice.call(arguments)), target = _ref[0], name = _ref[1], block = _ref[2];
  }
  top = target;
  _ref1 = name.split('.');
  for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
    item = _ref1[_i];
    target = target[item] || (target[item] = {});
  }
  return block(target, top);
};

closest = function(elem, selector) {
  var matchesSelector;
  matchesSelector = elem.matches || elem.webkitMatchesSelector || elem.mozMatchesSelector || elem.msMatchesSelector;
  while (elem) {
    if (matchesSelector.bind(elem)(selector)) {
      return elem;
    } else {
      elem = elem.parentElement;
    }
  }
  return false;
};

isEmptyOrDefault = function(el) {
  if (el.value === "" || el.value === el.defaultValue) {
    return true;
  } else {
    return false;
  }
};

hasFormValidation = function() {
  return typeof document.createElement("input").checkValidity === "function";
};

capitaliseFirstLetter = function(string) {
  return string.charAt(0).toUpperCase() + string.slice(1);
};

lowercaseFirstLetter = function(string) {
  return string.charAt(0).toLowerCase() + string.slice(1);
};

namespaceExists = function(obj, path) {
  var i, part, parts, root;
  parts = path.split(".");
  root = obj;
  i = 0;
  while (i < parts.length) {
    part = parts[i];
    if (root[part] && root.hasOwnProperty(part)) {
      root = root[part];
    } else {
      return false;
    }
    i++;
  }
  return true;
};

detectIE = function() {
  var msie, rv, trident, ua;
  ua = window.navigator.userAgent;
  msie = ua.indexOf("MSIE ");
  trident = ua.indexOf("Trident/");
  if (msie > 0) {
    return parseInt(ua.substring(msie + 5, ua.indexOf(".", msie)), 10);
  }
  if (trident > 0) {
    rv = ua.indexOf("rv:");
    return parseInt(ua.substring(rv + 3, ua.indexOf(".", rv)), 10);
  }
  return false;
};

functionName = function(fun) {
  var ret;
  ret = fun.toString();
  ret = ret.substr("function ".length);
  ret = ret.substr(0, ret.indexOf("("));
  return ret;
};

devConsoleLog = function(log) {
  if (Tok3nDashboard.Environment.isDevelopment) {
    return console.log(log);
  }
};

root = typeof exports !== "undefined" && exports !== null ? exports : this;

root._gaq = [['_setAccount', 'UA-39917560-2'], ['_trackPageview']];

Tok3nDashboard.typekit = 'nls8ikc';

ee = new EventEmitter();

Modernizr.addTest("extrinsicsizing", function() {
  var el, prop, value;
  prop = "width:";
  value = "min-content;";
  el = document.createElement("div");
  el.style.cssText = prop + Modernizr._prefixes.join(value + prop);
  return !!el.style.length;
});

Modernizr.addTest("csscalc", function() {
  var el, prop, value;
  prop = "width:";
  value = "calc(10px);";
  el = document.createElement("div");
  el.style.cssText = prop + Modernizr._prefixes.join(value + prop);
  return !!el.style.length;
});
