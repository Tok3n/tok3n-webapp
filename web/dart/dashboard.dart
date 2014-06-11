import 'dart:html';
import 'dart:js';
import 'dart:async';

void main() {
  // Initialize page. Set current window, call resizeContent (that's on the vanilla side),
  // and listen for window switching on the left menu.
  // querySelector('#tok3nIntegrations').classes.add('tok3n-pt-page-current');
  context.callMethod('resizeContent');
  selectWindow();

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

// Resize parent height if the content changes
void resizeContent() {
  context.callMethod('resizeContent');
}

void selectWindow() {
  // Change these values depending on your html layout and css.
  ElementList options = querySelectorAll('#tok3nSidebarMenu li');
  String menuItemAnchorClass = 'tok3n-menu-item';
  String menuItemSelectedClass = 'tok3n-sidebar-selected';
  Element previousOption = querySelector('#tok3nSidebarMenu li.' + menuItemSelectedClass);
  // Change these values depending on your css animations.
//  Duration cssAnimationDuration = new Duration(milliseconds:250);
  String currentVisibleAnchorClass = 'tok3n-pt-page-current';
  String fromCssAnimClassPrefix = 'tok3n-move-from-';
  String toCssAnimClassPrefix = 'tok3n-move-to-';
  String originCssAnimClass = 'left';
  String destCssAnimClass = 'right';
  List<String> animationClasses = [fromCssAnimClassPrefix + originCssAnimClass,
                                   fromCssAnimClassPrefix + destCssAnimClass,
                                   toCssAnimClassPrefix + originCssAnimClass,
                                   toCssAnimClassPrefix + destCssAnimClass,];
  // Dynamic vars
  int optionCount = options.length;
  // These vars are set after the first iteration, they will be null on the first execution
  // (refer to the last 4 lines of selectWindow())
  String previousTargetId = previousOption.getAttribute("data-target").toString();
  Element previousTarget = querySelector(previousTargetId);

  // Each time the menu is clicked
  options.forEach((Element option){
    option.onClick.listen((ev) {
      // Get the menu item that was clicked
      Element nextOption() {
        Element el;
        if (ev.target.classes.contains(menuItemAnchorClass)) {
          el = ev.target;
        } else {
          el = findClosestAncestor(ev.target, menuItemAnchorClass);
        }
        return el;
      }
      // If the target exists
      if (querySelector(nextOption().getAttribute("data-target")) != null) {
        String nextTargetId = nextOption().getAttribute("data-target").toString();
        Element nextTarget = querySelector(nextTargetId);
        // Which side we should move the content, depending on the previous item
        String animationSide(String side) {
          String str;
          if (childNodeIndex(nextOption()) < childNodeIndex(previousOption)) {
            if (side == 'previous') { str = originCssAnimClass; }
            else if (side == 'next') { str = destCssAnimClass; }
          } else if (childNodeIndex(nextOption()) > childNodeIndex(previousOption)) {
            if (side == 'previous') { str = destCssAnimClass; }
            else if (side == 'next') { str = originCssAnimClass; }
          }
          return str;
        }
        // Slide content if the element we clicked is different than the current selected one
        if ((childNodeIndex(nextOption()) == childNodeIndex(previousOption)) == false) {
          // Remove any previous and add new animation classes
          previousTarget.classes
            ..removeAll(animationClasses)
            ..add(toCssAnimClassPrefix + animationSide('previous'));
          nextTarget.classes
            ..removeAll(animationClasses)
            ..add(currentVisibleAnchorClass)
            ..add(fromCssAnimClassPrefix + animationSide('next'));
          // Select menu item for user feedback
          previousOption.classes.toggle(menuItemSelectedClass);
          nextOption().classes.toggle(menuItemSelectedClass);
          // Flush content resizing
          resizeContent();
          // Prepare for next iteration
          previousOption = nextOption();
          previousTargetId = previousOption.getAttribute("data-target").toString();
          previousTarget = querySelector(previousTargetId);
        }
      }
    });
  });
}