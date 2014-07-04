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

ee = new EventEmitter()
