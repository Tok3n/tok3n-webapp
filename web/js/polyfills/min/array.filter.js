Array.prototype.filter=function(a){"use strict";var b,c,d,e,f,g;if(void 0===this||null===this)throw new TypeError;if(e=Object(this),c=e.length>>>0,"function"!=typeof a)throw new TypeError;for(d=[],f=arguments_.length>=2?arguments_[1]:void 0,b=0;c>b;)b in e&&(g=e[b],a.call(f,g,b,e)&&d.push(g)),b++;return d};