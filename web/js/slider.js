(function() {

  /*
  Sliding login window
   */
  var animationClasses, removeAnimationClasses, slider;
  animationClasses = ['tok3n-move-from-left', 'tok3n-move-to-left', 'tok3n-move-from-right', 'tok3n-move-to-right'];
  removeAnimationClasses = function(el) {
    return each(animationClasses, function(cl) {
      return el.classList.remove(cl);
    });
  };
  slider = function() {
    var menuItemAnchorClass, menuItemSelectedClass, options, previousOption, previousTarget, previousTargetId;
    options = querySelectorAll("#tok3nSidebarMenu li");
    menuItemAnchorClass = "tok3n-menu-item";
    menuItemSelectedClass = "tok3n-sidebar-selected";
    previousOption = qs("#tok3nSidebarMenu li." + menuItemSelectedClass);
    previousTargetId = previousOption.getAttribute("data-target").toString();
    previousTarget = gebi(previousTargetId);
    options.forEach(function(el) {
      el.addEventListener("click", function(evt) {
        var animationSlide, nextOption, nextTarget, nextTargetId, temp;
        nextOption = evt.target.classList.contains(menuItemAnchorClass) ? evt.target : findClosestAncestor(evt.target, menuItemAnchorClass);
        if (previousOption !== nextOption) {
          previousOption.classList.remove(menuItemSelectedClass);
          nextOption.classList.add(menuItemSelectedClass);
        }
        nextTargetId = nextOption.getAttribute("data-target").toString();
        nextTarget = gebi(nextTargetId);
        temp = void 0;
        animationSlide = function(option) {
          if (option !== "previous" && option !== "next") {
            return;
          }
          if (childNodeIndex(nextOption) < childNodeIndex(previousOption)) {
            if (option === "previous") {
              return "left";
            } else {
              return "right";
            }
          } else if (childNodeIndex(nextOption) > childNodeIndex(previousOption)) {
            if (option === "previous") {
              return "right";
            } else {
              return "left";
            }
          } else {
            return false;
          }
        };
        if (childNodeIndex(nextOption) !== childNodeIndex(previousOption)) {
          removeAnimationClasses(previousTarget);
          Tok3nDashboard.nextTarget = nextTarget;
          Tok3nDashboard.previousTarget = previousTarget;
          ee.emitEvent('tok3nSlideBeforeAnimation');
          previousTarget.classList.add("tok3n-move-to-" + (animationSlide('previous')));
          temp = previousTarget;
          setTimeout(function() {
            temp.classList.remove("tok3n-pt-page-previous");
            temp.classList.remove("tok3n-pt-page-current");
            Tok3nDashboard.tempPreviousTarget = temp;
            return ee.emitEvent('tok3nSlideAfterAnimation');
          }, 250);
          removeAnimationClasses(nextTarget);
          nextTarget.classList.add("tok3n-pt-page-current");
          nextTarget.classList.add("tok3n-move-from-" + (animationSlide('next')));
        }
        previousOption = nextOption;
        previousTargetId = previousOption.getAttribute("data-target").toString();
        return previousTarget = gebi(previousTargetId);
      });
    });
  };
  return Tok3nDashboard.slider = slider;
})();
