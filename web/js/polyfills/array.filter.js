Array.prototype.filter = function(fun) {
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