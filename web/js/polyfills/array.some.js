Array.prototype.some = function(fun, thisArg) {
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