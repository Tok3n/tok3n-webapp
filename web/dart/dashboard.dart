import 'dart:html';
import 'dart:js';
import 'dart:async';

void main() {
  //  context.callMethod('resizeContent');
  // Flip cards
  querySelectorAll('.tok3n-cards-container .front').forEach((Element e) {
    e.onClick.listen((Event ev) {
      findClosestAncestor(e, 'flipper').classes.toggle('flipped');
      e.parent.children.where((f) => f.classes.contains('back')).forEach((Element g) {
        g.style.zIndex = "3";
      });
    });
  });
  querySelectorAll('.tok3n-cards-container .flip').forEach((Element e) {
    e.onClick.listen((ev) {
      findClosestAncestor(e, 'flipper').classes.toggle('flipped');
    });
  });

  // Toggle show/hide secret
  ElementList toggleSecretShow = querySelectorAll('.toggle-secret');
  if (toggleSecretShow != null) {
    toggleSecretShow.forEach((Element el) {
      el.onClick.listen((Event ev) {
        el.parent.children.where((f) => f.classes.contains('secret')).forEach((Element g) {
          g.classes.toggle('hidden');
        });
      });
    });
  }
  querySelectorAll('.tok3n-new-integration-kind .tok3n-new-integration-kind-radio').forEach((Element el) {
    el.onClick.listen((Event ev) {
      Element implementationSelected = el.querySelector('input[type="radio"]:checked');
      if (implementationSelected != null) {
        String implementationKind = implementationSelected.getAttribute('value');
        Element callbackUrl = findClosestAncestor(implementationSelected, 'tok3n-integration-new-form').querySelector('.tok3n-new-integration-callback-url');
        if (implementationKind == 'web' && callbackUrl.classes.contains('collapsed')) {
          callbackUrl.classes.remove('collapsed');
          new Timer(new Duration(milliseconds:500), () {resizeContent();});
        } else if (implementationKind == 'general' && callbackUrl.classes.contains('collapsed') == false) {
          callbackUrl.classes.add('collapsed');
        }
      }
    });
  });
}

Element findClosestAncestor(Element element, String ancestorTagName) {
  Element parent = element.parent;
  while(parent.classes.contains(ancestorTagName) == false) {
    parent = parent.parent;
  }
  return parent;
}