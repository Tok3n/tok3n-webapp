window.Tok3nDashboard or= {}
Tok3nDashboard.Environment or= {}
Tok3nDashboard.Jsapi or= {}
Tok3nDashboard.Charts or= {}
Tok3nDashboard.Screens or= {}
Tok3nDashboard.CurrentScreens or= []
Tok3nDashboard.cdnUrl = '//s3.amazonaws.com/static.tok3n.com/tok3n-webapp'
Tok3nDashboard.initWindow or= 'Devices'

unless Tok3nDashboard.Environment.isDevelopment
  Tok3nDashboard.Environment.isProduction = true
else
  Tok3nDashboard.Environment.isProduction = false

# Easy function references
each = Function.prototype.call.bind [].forEach
indexOf = Function.prototype.call.bind [].indexOf
slice = Function.prototype.call.bind [].slice
qs = document.querySelector.bind document
qsa = document.querySelectorAll.bind document
gebi = document.getElementById.bind document

# Custom functions converted to Arrays instead of Nodes.
querySelectorAll = ( selector ) ->
  slice document.querySelectorAll selector
forEach = (list, callback) ->
  Array::forEach.call list, callback
  return

# Useful funcs
childNodeIndex = ( el ) ->
  indexOf el.parentNode.children, el
findClosestAncestor = ( el, ancestorTag ) ->
  parentEl = el.parentElement
  until parentEl.classList.contains ancestorTag
    parentEl = parentEl.parentElement
  parentEl
namespace = (target, name, block) ->
  [target, name, block] = [(if typeof exports isnt 'undefined' then exports else window), arguments...] if arguments.length < 3
  top    = target
  target = target[item] or= {} for item in name.split '.'
  block target, top
closest = (elem, selector) ->
  matchesSelector = elem.matches or elem.webkitMatchesSelector or elem.mozMatchesSelector or elem.msMatchesSelector
  while elem
    if matchesSelector.bind(elem)(selector)
      return elem
    else
      elem = elem.parentElement
  false
isEmptyOrDefault = ( el ) ->
  if el.value is "" or el.value is el.defaultValue
    true
  else
    false
hasFormValidation = ->
  typeof document.createElement("input").checkValidity is "function"
capitaliseFirstLetter = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)
lowercaseFirstLetter = (string) ->
  string.charAt(0).toLowerCase() + string.slice(1)
# http://stackoverflow.com/a/6548416/697892
namespaceExists = (obj, path) ->
  parts = path.split(".")
  root = obj
  i = 0
  while i < parts.length
    part = parts[i]
    if root[part] and root.hasOwnProperty(part)
      root = root[part]
    else
      return false
    i++
  true
detectIE = ->
  ua = window.navigator.userAgent
  msie = ua.indexOf("MSIE ")
  trident = ua.indexOf("Trident/")
  # IE 10 or older => return version number
  return parseInt(ua.substring(msie + 5, ua.indexOf(".", msie)), 10)  if msie > 0
  if trident > 0
    # IE 11 (or newer) => return version number
    rv = ua.indexOf("rv:")
    return parseInt(ua.substring(rv + 3, ua.indexOf(".", rv)), 10)
  # other browser
  false
functionName = (fun) ->
  ret = fun.toString()
  ret = ret.substr("function ".length)
  ret = ret.substr(0, ret.indexOf("("))
  ret

# Google Analytics
root = exports ? this
root._gaq = [['_setAccount', 'UA-39917560-2'], ['_trackPageview']]

# Typekit
Tok3nDashboard.typekit = 'nls8ikc'

# Libs
ee = new EventEmitter()

Modernizr.addTest "extrinsicsizing", ->
  prop = "width:"
  value = "min-content;"
  el = document.createElement("div")
  el.style.cssText = prop + Modernizr._prefixes.join(value + prop)
  !!el.style.length

Modernizr.addTest "csscalc", ->
  prop = "width:"
  value = "calc(10px);"
  el = document.createElement("div")
  el.style.cssText = prop + Modernizr._prefixes.join(value + prop)
  !!el.style.length