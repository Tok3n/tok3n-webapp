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

  // This is just an example. Change to reflect real errors
  querySelectorAll('.tok3n-header').forEach((Element e) {
    e.onClick.listen((ev) => alertTextAppear(e));
  });

  // Select default option. This example is hardcoded, but it should
  // be QR in case the user has enabled it. Otherwise, OTP, else SMS.
  querySelector('#tok3nQR').setAttribute('checked','checked');
  querySelector('#tok3nQrPage').classes.add('tok3n-pt-page-current');

  slideAuthenticator();
}


int childNodeIndex(Element e) {
  var parent = e.parentNode;
  var children = parent.children;
  int count = children.length;
  int child_index;
  for (var i = 0; i < count; i++) {
    if (e == children[i]) {
      child_index = i;
      break;
    }
  }
  return child_index;
}

void slideAuthenticator() {
  Element menu = querySelector('#tok3nRadioSlider');
  ElementList options = querySelectorAll('$menu > input[type="radio"]');
  int optionCount = options.length;
  Element currentOption = querySelector('#tok3nRadioSlider input[type="radio"]:checked');
  Element currentTarget = querySelector("#" + currentOption.getAttribute("data-target").toString());


  options.forEach((InputElement e){
    e.onClick.listen((ev) {
      Element nextOption = ev.target;
      Element nextTarget = querySelector("#" + nextOption.getAttribute("data-target").toString());
      Element temp;

      var animationClasses = ['tok3n-move-from-left', 'tok3n-move-to-left', 'tok3n-move-from-right', 'tok3n-move-to-right'];

      if (childNodeIndex(nextOption) == childNodeIndex(currentOption)) {
//        Do nothing 'cause it's the same one
//    Clicked option on the right side of currently selected option
      } else if (childNodeIndex(nextOption) < childNodeIndex(currentOption)) {
//      Current move to left, Next move from right
        currentTarget.classes
          ..removeAll(animationClasses)
          ..add('tok3n-move-to-left');
         temp = currentTarget;
        new Timer(new Duration(milliseconds:250), () {temp.classes.remove('tok3n-pt-page-current');});
        nextTarget.classes
          ..removeAll(animationClasses)
          ..add('tok3n-pt-page-current')
          ..add('tok3n-move-from-right');

//    Clicked option on the left side
      } else {
//      Current move to right, Next move from left
        currentTarget.classes
          ..removeAll(animationClasses)
          ..add('tok3n-move-to-right');
        temp = currentTarget;
        new Timer(new Duration(milliseconds:250), () {temp.classes.remove('tok3n-pt-page-current');});
        nextTarget.classes
          ..removeAll(animationClasses)
          ..add('tok3n-pt-page-current')
          ..add('tok3n-move-from-left');
      }

      currentOption = nextOption;
      currentTarget = querySelector("#" + currentOption.getAttribute("data-target").toString());
    });
  });
}

void changeClasssToEmpty(InputElement e) {
  e.classes.toggle("empty", e.value=="");
}

void flipCardOnSubmit(Element e) {
  // Please remove the timer after connecting with the backend.
  // The card should flip *after* the qrcode image has been
  // generated AND has been fully loaded.
  new Timer(new Duration(milliseconds:1500), () {
    querySelectorAll('.tok3n-flipper').forEach((Element f){
      f.classes.toggle('tok3n-flipped');
    });
    querySelectorAll('.tok3n-back').forEach((Element f){
      f.classes.toggle('tok3n-ontop'); // If you know what I mean...
    });
  });
}

void toggleAnimationClass(Element e, String addCls, String removCls){
  // Slight hack to add animation class or remove and add again
  // to render animation again.
  if (e.classes.contains(addCls)) {
      e.classes.remove(addCls);
      new Timer(new Duration(milliseconds:0), () {
        e.classes.add(addCls);
      });
  } else {
    e
    ..classes.remove(removCls)
    ..classes.add(addCls);
  }
}

// Of course this should be only used after the corresponding text
// is added.
void alertTextAppear(Element e) {
  querySelectorAll('.tok3n-login-alert').forEach((Element f){
    toggleAnimationClass(f, 'tok3n-login-alert-active', 'tok3n-login-alert-hidden');
  });
}