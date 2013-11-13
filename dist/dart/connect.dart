import 'dart:html';

void main() {
  querySelectorAll("input:not([value]),input[value='']").forEach((Element e)=>e.classes.add("empty"));
  querySelectorAll("input").forEach((InputElement e){
     e
     ..onInput.listen((ev)=>changeClasss(e))
     ..onKeyUp.listen((ev)=>changeClasss(e));
  });
}

void changeClasss(InputElement e){
  e.classes.toggle("empty", e.value=="");
}