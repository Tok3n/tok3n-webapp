import 'dart:html';

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
}


Element findClosestAncestor(Element element, String ancestorTagName) {
  Element parent = element.parent;
  while(parent.classes.contains(ancestorTagName) == false) {
    parent = parent.parent;
    if (parent == null) {
      // Throw, or find some other way to handle the tagName not being found.
      throw '$ancestorTagName not found';
    }
  }
  return parent;
}