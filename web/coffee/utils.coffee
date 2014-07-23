window.Tok3nDashboard or= {}
Tok3nDashboard.Environment or= {}
Tok3nDashboard.Jsapi or= {}
Tok3nDashboard.Charts or= {}
Tok3nDashboard.ValidatedForms or= []

unless Tok3nDashboard.Environment.isDevelopment
  Tok3nDashboard.Environment.isProduction = true
else
  Tok3nDashboard.Environment.isProduction = false

# easy refs for various things
each = Function.prototype.call.bind [].forEach
indexOf = Function.prototype.call.bind [].indexOf
slice = Function.prototype.call.bind [].slice
qs = document.querySelector.bind document
qsa = document.querySelectorAll.bind document
gebi = document.getElementById.bind document
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

# Google Analytics
root = exports ? this
root._gaq = [['_setAccount', 'UA-39917560-2'], ['_trackPageview']]

# Typekit
Tok3nDashboard.typekit = 'nls8ikc'

# Libs
ee = new EventEmitter()

# Modernizr.addTest "csscalc", ->
#   prop = "width:"
#   value = "calc(10px);"
#   el = document.createElement("div")
#   el.style.cssText = prop + Modernizr._prefixes.join(value + prop)
#   !!el.style.length