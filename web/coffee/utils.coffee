window.Tok3nDashboard or= {}

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

# Google Analytics
root = exports ? this
root._gaq = [['_setAccount', 'UA-39917560-2'], ['_trackPageview']]

# Libs
ee = new EventEmitter()

# Modernizr.addTest "csscalc", ->
#   prop = "width:"
#   value = "calc(10px);"
#   el = document.createElement("div")
#   el.style.cssText = prop + Modernizr._prefixes.join(value + prop)
#   !!el.style.length