/*!
 * tok3n-webapp v0.0.1 - 2014-03-23
 * Front-end for Tok3n Webapp
 * Automatically generated by Grunt.js
 */
/*!
 * Copyright (c) 2011-2013 Felix Gnass
 * Licensed under the MIT license
 */
!function(a,b){"object"==typeof exports?module.exports=b():"function"==typeof define&&define.amd?define(b):a.Spinner=b()}(this,function(){"use strict";function a(a,b){var c,d=document.createElement(a||"div");for(c in b)d[c]=b[c];return d}function b(a){for(var b=1,c=arguments.length;c>b;b++)a.appendChild(arguments[b]);return a}function c(a,b,c,d){var e=["opacity",b,~~(100*a),c,d].join("-"),f=.01+c/d*100,g=Math.max(1-(1-a)/b*(100-f),a),h=j.substring(0,j.indexOf("Animation")).toLowerCase(),i=h&&"-"+h+"-"||"";return l[e]||(m.insertRule("@"+i+"keyframes "+e+"{0%{opacity:"+g+"}"+f+"%{opacity:"+a+"}"+(f+.01)+"%{opacity:1}"+(f+b)%100+"%{opacity:"+a+"}100%{opacity:"+g+"}}",m.cssRules.length),l[e]=1),e}function d(a,b){var c,d,e=a.style;if(void 0!==e[b])return b;for(b=b.charAt(0).toUpperCase()+b.slice(1),d=0;d<k.length;d++)if(c=k[d]+b,void 0!==e[c])return c}function e(a,b){for(var c in b)a.style[d(a,c)||c]=b[c];return a}function f(a){for(var b=1;b<arguments.length;b++){var c=arguments[b];for(var d in c)void 0===a[d]&&(a[d]=c[d])}return a}function g(a){for(var b={x:a.offsetLeft,y:a.offsetTop};a=a.offsetParent;)b.x+=a.offsetLeft,b.y+=a.offsetTop;return b}function h(a){return"undefined"==typeof this?new h(a):void(this.opts=f(a||{},h.defaults,n))}function i(){function c(b,c){return a("<"+b+' xmlns="urn:schemas-microsoft.com:vml" class="spin-vml">',c)}m.addRule(".spin-vml","behavior:url(#default#VML)"),h.prototype.lines=function(a,d){function f(){return e(c("group",{coordsize:j+" "+j,coordorigin:-i+" "+-i}),{width:j,height:j})}function g(a,g,h){b(l,b(e(f(),{rotation:360/d.lines*a+"deg",left:~~g}),b(e(c("roundrect",{arcsize:d.corners}),{width:i,height:d.width,left:d.radius,top:-d.width>>1,filter:h}),c("fill",{color:d.color,opacity:d.opacity}),c("stroke",{opacity:0}))))}var h,i=d.length+d.width,j=2*i,k=2*-(d.width+d.length)+"px",l=e(f(),{position:"absolute",top:k,left:k});if(d.shadow)for(h=1;h<=d.lines;h++)g(h,-2,"progid:DXImageTransform.Microsoft.Blur(pixelradius=2,makeshadow=1,shadowopacity=.3)");for(h=1;h<=d.lines;h++)g(h);return b(a,l)},h.prototype.opacity=function(a,b,c,d){var e=a.firstChild;d=d.shadow&&d.lines||0,e&&b+d<e.childNodes.length&&(e=e.childNodes[b+d],e=e&&e.firstChild,e=e&&e.firstChild,e&&(e.opacity=c))}}var j,k=["webkit","Moz","ms","O"],l={},m=function(){var c=a("style",{type:"text/css"});return b(document.getElementsByTagName("head")[0],c),c.sheet||c.styleSheet}(),n={lines:12,length:7,width:5,radius:10,rotate:0,corners:1,color:"#000",direction:1,speed:1,trail:100,opacity:.25,fps:20,zIndex:2e9,className:"spinner",top:"auto",left:"auto",position:"relative"};h.defaults={},f(h.prototype,{spin:function(b){this.stop();var c,d,f=this,h=f.opts,i=f.el=e(a(0,{className:h.className}),{position:h.position,width:0,zIndex:h.zIndex}),k=h.radius+h.length+h.width;if(b&&(b.insertBefore(i,b.firstChild||null),d=g(b),c=g(i),e(i,{left:("auto"==h.left?d.x-c.x+(b.offsetWidth>>1):parseInt(h.left,10)+k)+"px",top:("auto"==h.top?d.y-c.y+(b.offsetHeight>>1):parseInt(h.top,10)+k)+"px"})),i.setAttribute("role","progressbar"),f.lines(i,f.opts),!j){var l,m=0,n=(h.lines-1)*(1-h.direction)/2,o=h.fps,p=o/h.speed,q=(1-h.opacity)/(p*h.trail/100),r=p/h.lines;!function s(){m++;for(var a=0;a<h.lines;a++)l=Math.max(1-(m+(h.lines-a)*r)%p*q,h.opacity),f.opacity(i,a*h.direction+n,l,h);f.timeout=f.el&&setTimeout(s,~~(1e3/o))}()}return f},stop:function(){var a=this.el;return a&&(clearTimeout(this.timeout),a.parentNode&&a.parentNode.removeChild(a),this.el=void 0),this},lines:function(d,f){function g(b,c){return e(a(),{position:"absolute",width:f.length+f.width+"px",height:f.width+"px",background:b,boxShadow:c,transformOrigin:"left",transform:"rotate("+~~(360/f.lines*i+f.rotate)+"deg) translate("+f.radius+"px,0)",borderRadius:(f.corners*f.width>>1)+"px"})}for(var h,i=0,k=(f.lines-1)*(1-f.direction)/2;i<f.lines;i++)h=e(a(),{position:"absolute",top:1+~(f.width/2)+"px",transform:f.hwaccel?"translate3d(0,0,0)":"",opacity:f.opacity,animation:j&&c(f.opacity,f.trail,k+i*f.direction,f.lines)+" "+1/f.speed+"s linear infinite"}),f.shadow&&b(h,e(g("#000","0 0 4px #000"),{top:"2px"})),b(d,b(h,g(f.color,"0 0 1px rgba(0,0,0,.1)")));return d},opacity:function(a,b,c){b<a.childNodes.length&&(a.childNodes[b].style.opacity=c)}});var o=e(a("group"),{behavior:"url(#default#VML)"});return!d(o,"transform")&&o.adj?i():j=d(o,"animation"),h}),/*!
 * Ladda
 * http://lab.hakim.se/ladda
 * MIT licensed
 *
 * Copyright (C) 2013 Hakim El Hattab, http://hakim.se
 */
function(a,b){"object"==typeof exports?module.exports=b():"function"==typeof define&&define.amd?define(["spin"],b):a.Ladda=b(a.Spinner)}(this,function(a){"use strict";function b(a){if("undefined"==typeof a)return void console.warn("Ladda button target must be defined.");a.querySelector(".ladda-label")||(a.innerHTML='<span class="ladda-label">'+a.innerHTML+"</span>");var b,c=document.createElement("span");c.className="ladda-spinner",a.appendChild(c);var d,e={start:function(){return b||(b=g(a)),a.setAttribute("disabled",""),a.setAttribute("data-loading",""),clearTimeout(d),b.spin(c),this.setProgress(0),this},startAfter:function(a){return clearTimeout(d),d=setTimeout(function(){e.start()},a),this},stop:function(){return a.removeAttribute("disabled"),a.removeAttribute("data-loading"),clearTimeout(d),b&&(d=setTimeout(function(){b.stop()},1e3)),this},toggle:function(){return this.isLoading()?this.stop():this.start(),this},setProgress:function(b){b=Math.max(Math.min(b,1),0);var c=a.querySelector(".ladda-progress");0===b&&c&&c.parentNode?c.parentNode.removeChild(c):(c||(c=document.createElement("div"),c.className="ladda-progress",a.appendChild(c)),c.style.width=(b||0)*a.offsetWidth+"px")},enable:function(){return this.stop(),this},disable:function(){return this.stop(),a.setAttribute("disabled",""),this},isLoading:function(){return a.hasAttribute("data-loading")}};return i.push(e),e}function c(a,b){for(;a.parentNode&&a.tagName!==b;)a=a.parentNode;return b===a.tagName?a:void 0}function d(a){for(var b=["input","textarea"],c=[],d=0;d<b.length;d++)for(var e=a.getElementsByTagName(b[d]),f=0;f<e.length;f++)e[f].hasAttribute("required")&&c.push(e[f]);return c}function e(a,e){e=e||{};var f=[];"string"==typeof a?f=h(document.querySelectorAll(a)):"object"==typeof a&&"string"==typeof a.nodeName&&(f=[a]);for(var g=0,i=f.length;i>g;g++)!function(){var a=f[g];if("function"==typeof a.addEventListener){var h=b(a),i=-1;a.addEventListener("click",function(){var b=!0,f=c(a,"FORM");if("undefined"!=typeof f)for(var g=d(f),j=0;j<g.length;j++)""===g[j].value.replace(/^\s+|\s+$/g,"")&&(b=!1);b&&(h.startAfter(1),"number"==typeof e.timeout&&(clearTimeout(i),i=setTimeout(h.stop,e.timeout)),"function"==typeof e.callback&&e.callback.apply(null,[h]))},!1)}}()}function f(){for(var a=0,b=i.length;b>a;a++)i[a].stop()}function g(b){var c,d=b.offsetHeight;0===d&&(d=parseFloat(window.getComputedStyle(b).height)),d>32&&(d*=.8),b.hasAttribute("data-spinner-size")&&(d=parseInt(b.getAttribute("data-spinner-size"),10)),b.hasAttribute("data-spinner-color")&&(c=b.getAttribute("data-spinner-color"));var e=12,f=.2*d,g=.6*f,h=7>f?2:3;return new a({color:c||"#fff",lines:e,radius:f,length:g,width:h,zIndex:"auto",top:"auto",left:"auto",className:""})}function h(a){for(var b=[],c=0;c<a.length;c++)b.push(a[c]);return b}var i=[];return{bind:e,create:b,stopAll:f}});var WebFontConfig,insertGAScript,root;WebFontConfig={google:{families:["Arvo:400italic:latin"]}},function(){var a,b;b=document.createElement("script"),b.src=("https:"===document.location.protocol?"https":"http")+"://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js",b.type="text/javascript",b.async="true",a=document.getElementsByTagName("script")[0],a.parentNode.insertBefore(b,a)}(),Ladda.bind("#tok3nLogin",{timeout:5e3}),Ladda.bind("#tok3nVerify",{timeout:5e3}),document.getElementById("tok3nOtpInput").oninput=function(){this.value.length>6&&(this.value=this.value.slice(0,6))},document.getElementById("tok3nSmsInput").oninput=function(){this.value.length>6&&(this.value=this.value.slice(0,6))},root="undefined"!=typeof exports&&null!==exports?exports:this,root._gaq=[["_setAccount","UA-39917560-2"],["_trackPageview"]],(insertGAScript=function(){var a,b,c;return a=document.createElement("script"),a.type="text/javascript",a.async=!0,b=document.location.protocol,b="https:"===b?"https://ssl":"http://www",a.src=""+b+".google-analytics.com/ga.js",c=document.getElementsByTagName("script")[0],c.parentNode.insertBefore(a,c)})();