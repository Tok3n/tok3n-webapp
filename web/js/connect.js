var WebFontConfig, insertGAScript, root;

WebFontConfig = {
  google: {
    families: ["Arvo:400italic:latin"]
  }
};

(function() {
  var s, wf;
  wf = document.createElement("script");
  wf.src = ("https:" === document.location.protocol ? "https" : "http") + "://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js";
  wf.type = "text/javascript";
  wf.async = "true";
  s = document.getElementsByTagName("script")[0];
  s.parentNode.insertBefore(wf, s);
})();

Ladda.bind('#tok3nLogin', {
  timeout: 5000
});

Ladda.bind('#tok3nVerify', {
  timeout: 5000
});

document.getElementById("tok3nOtpInput").oninput = function() {
  if (this.value.length > 6) {
    this.value = this.value.slice(0, 6);
  }
};

document.getElementById("tok3nSmsInput").oninput = function() {
  if (this.value.length > 6) {
    this.value = this.value.slice(0, 6);
  }
};

root = typeof exports !== "undefined" && exports !== null ? exports : this;

root._gaq = [['_setAccount', 'UA-39917560-2'], ['_trackPageview']];

insertGAScript = function() {
  var ga, proto, s;
  ga = document.createElement('script');
  ga.type = 'text/javascript';
  ga.async = true;
  proto = document.location.protocol;
  proto = proto === 'https:' ? 'https://ssl' : 'http://www';
  ga.src = "" + proto + ".google-analytics.com/ga.js";
  s = document.getElementsByTagName('script')[0];
  return s.parentNode.insertBefore(ga, s);
};

insertGAScript();
