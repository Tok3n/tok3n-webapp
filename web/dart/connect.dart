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
    e.onClick.listen((ev) => alertTextAppear());
  });

  querySelector('#tok3nCreateAccount').onClick.listen((ev) =>
      alertTextRemove());
  querySelector('#TestTest').onClick.listen((ev) =>
      alertTextRemove());

  // Select default option. This example is hardcoded, but it should
  // be QR in case the user has enabled it. Otherwise, OTP, else SMS.
  querySelector('#tok3nQR').setAttribute('checked','checked');
  querySelector('#tok3nQrPage').classes.add('tok3n-pt-page-current');

  slideAuthenticator();
}

// Check which numeric position has an element in its parent node, to see if it is after or before another element.
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
  Element previousOption = querySelector('#tok3nRadioSlider input[type="radio"]:checked');
  String previousTargetId = "#" + previousOption.getAttribute("data-target").toString();
  Element previousTarget = querySelector(previousTargetId);

  options.forEach((InputElement e){
    e.onClick.listen((ev) {
      Element nextOption = ev.target;
      String nextTargetId = "#" + nextOption.getAttribute("data-target").toString();
      Element nextTarget = querySelector(nextTargetId);
      Element temp;

      var animationClasses = ['tok3n-move-from-left', 'tok3n-move-to-left', 'tok3n-move-from-right', 'tok3n-move-to-right'];

      String animationSide(String option) {
        String str;
        if (childNodeIndex(nextOption) < childNodeIndex(previousOption)) {
          if (option == 'previous') { str = 'left'; } else if (option == 'next') { str = 'right'; }
        } else if (childNodeIndex(nextOption) > childNodeIndex(previousOption)) {
          if (option == 'previous') { str = 'right'; } else if (option == 'next') { str = 'left'; }
        }
        return str;
      }

      if ((childNodeIndex(nextOption) == childNodeIndex(previousOption)) == false) {
        // Slide button
        previousTarget.classes
          ..removeAll(animationClasses)
          ..add('tok3n-move-to-' + animationSide('previous'));
        temp = previousTarget;
        new Timer(new Duration(milliseconds:250), () {temp.classes.remove('tok3n-pt-page-previous');});
        nextTarget.classes
          ..removeAll(animationClasses)
          ..add('tok3n-pt-page-current')
          ..add('tok3n-move-from-' + animationSide('next'));

        // Remove alert
        alertTextRemove();

        // Slide button
        Element verifyButton = querySelector('#tok3nVerifyWrapper');
        if (nextTargetId.toLowerCase().contains('qrpage')) {
          verifyButton.classes
            ..removeAll(animationClasses)
            ..add('tok3n-move-to-' + animationSide('previous'));
        } else if (previousTargetId.toLowerCase().contains('qrpage')) {
          verifyButton.classes
            ..removeAll(animationClasses)
            ..add('tok3n-move-to-' + animationSide('previous'));
          verifyButton.classes
            ..removeAll(animationClasses)
            ..add('tok3n-submit-visible')
            ..add('tok3n-move-from-' + animationSide('next'));
        }
      }

      previousOption = nextOption;
      previousTargetId = "#" + previousOption.getAttribute("data-target").toString();
      previousTarget = querySelector(previousTargetId);
    });
  });
}

void changeClasssToEmpty(InputElement e) {
  e.classes.toggle("empty", e.value=="");
}

void flipCardOnSubmit(Element e) {
  // Remove alert when the button is pressed
  alertTextRemove();

  // Please remove the timer after connecting with the backend.
  // The card should flip *after* the qrcode image has been generated AND has been fully loaded.
  new Timer(new Duration(milliseconds:1500), () {
    querySelectorAll('.tok3n-flipper').forEach((Element f){
      f.classes.toggle('tok3n-flipped');
    });
    querySelectorAll('.tok3n-back').forEach((Element f){
      f.classes.toggle('tok3n-ontop'); // If you know what I mean...
    });
//  alertTextAppear();
  });
}

void toggleAnimationClass(Element e, String addCls, String removCls){
  // Slight hack to add animation class or remove and add again to render animation again.
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

// Of course this should be only used after the corresponding text is added.
void alertTextAppear() {
  querySelectorAll('.tok3n-login-alert').forEach((Element f){
    toggleAnimationClass(f, 'tok3n-login-alert-active', 'tok3n-login-alert-hidden');
  });
}

void alertTextRemove() {
  querySelectorAll('.tok3n-login-alert').forEach((Element f){
    toggleAnimationClass(f, 'tok3n-login-alert-hidden', 'tok3n-login-alert-active');
  });
}