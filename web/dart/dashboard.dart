import 'dart:html';
import 'dart:js';
import 'dart:async';

void main() {
  querySelectorAll('#cards-container .front').forEach((Element e) {
    e.onClick.listen((ev) {
      findClosestAncestor(e, 'flipper').classes.toggle('flipped');
      e.parent.children.where((f) => f.classes.contains('back')).forEach((Element g) {
        g.style.zIndex = "3";
      });
    });
  });
  querySelectorAll('#cards-container .flip').forEach((Element e) {
    e.onClick.listen((ev) {
      findClosestAncestor(e, 'flipper').classes.toggle('flipped');
    });
  });
  querySelector('#tok3nIntegrations').classes.add('tok3n-pt-page-current');
  context.callMethod('resizeContent');

  selectWindow();
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

void selectWindow() {
  ElementList options = querySelectorAll('#sidebarMenu li');
  int optionCount = options.length;
  Element previousOption = querySelector('#sidebarMenu li.selected');
  String previousTargetId = "#" + previousOption.getAttribute("data-target").toString();
  Element previousTarget = querySelector(previousTargetId);

  options.forEach((Element e){
    e.onClick.listen((ev) {

      Element nextOption() {
        Element el;
        if (ev.target.classes.contains('tok3n-menu-item')) {
          el = ev.target;
        } else {
          el = findClosestAncestor(ev.target, 'tok3n-menu-item');
        }
        return el;
      }

      if (nextOption().classes != null && nextOption().classes.isNotEmpty) {
        String nextTargetId = "#" + nextOption().getAttribute("data-target").toString();
        Element nextTarget = querySelector(nextTargetId);
        Element temp;

        var animationClasses = ['tok3n-move-from-left', 'tok3n-move-to-left', 'tok3n-move-from-right', 'tok3n-move-to-right'];

        String animationSide(String option) {
          String str;
          if (childNodeIndex(nextOption()) < childNodeIndex(previousOption)) {
            if (option == 'previous') { str = 'left'; } else if (option == 'next') { str = 'right'; }
          } else if (childNodeIndex(nextOption()) > childNodeIndex(previousOption)) {
            if (option == 'previous') { str = 'right'; } else if (option == 'next') { str = 'left'; }
          }
          return str;
        }

        if ((childNodeIndex(nextOption()) == childNodeIndex(previousOption)) == false) {
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
        }
        if (nextOption().getAttribute("data-target") != null) {
          previousOption.classes.toggle('selected');
          nextOption().classes.toggle('selected');
          // Flush content resizing
          context.callMethod('resizeContent');
          previousOption = nextOption();
          previousTargetId = "#" + previousOption.getAttribute("data-target").toString();
          previousTarget = querySelector(previousTargetId);
        }
      }
    });
  });
}