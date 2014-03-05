import 'dart:html';
import 'dart:async';

void main() {
  // Float labels
  querySelectorAll("input:not([value]),input[value='']").forEach((Element e) =>
    e.classes.add("empty"));
  querySelectorAll("input").forEach((InputElement e){
    e.onInput.listen((ev) => changeClasssToEmpty(e));
    e.onClick.listen((ev) => changeClasssToEmpty(e));
  });
  querySelectorAll(".tok3n-submit").forEach((Element e){
    e.onClick.listen((ev) => flipCardOnSubmit(e));
  });
}

void changeClasssToEmpty(InputElement e) {
  e.classes.toggle("empty", e.value=="");
}

void flipCardOnSubmit(e) {
  // Please remove the timer after connecting with the backend.
  // The card should flip *after* the qrcode image has been generated AND has been fully loaded.
  new Timer(new Duration(milliseconds:500), () {
    querySelectorAll('.tok3n-flipper').forEach((Element f){
      f.classes.toggle('tok3n-flipped');
    });
    querySelectorAll('.tok3n-back').forEach((Element f){
      f.classes.toggle('tok3n-ontop'); // If you know what I mean...
    });
  });
}