(function() {
  Tok3nDashboard.Screens || (Tok3nDashboard.Screens = {});
  Tok3nDashboard.initWindow || (Tok3nDashboard.initWindow = 'Devices');
  return namespace('Tok3nDashboard.Screens', function(exports) {

    /*
    Sitewide
     */
    var countryCode, countrySelect, limitToSixChar, phoneNumber, selectCountryCode, toggleNextButton, toggleNextButtonOtp, toggleVerifyPassword;
    exports.sitewide = function() {
      var current;
      current = Tok3nDashboard.initWindow;
      document.getElementById("tok3n" + current).classList.add('tok3n-pt-page-current');
      document.getElementById("tok3n" + current + "MenuButton").classList.add('tok3n-sidebar-selected');
      return (function(el) {
        var WidthChange, menuItems, mq;
        if (el) {
          document.querySelector('#collapseSidebarButton').addEventListener('click', function() {
            return el.classList.toggle('collapsed');
          }, false);
          menuItems = querySelectorAll('.tok3n-menu-item');
          menuItems.forEach(function(item) {
            return item.addEventListener('click', function() {
              if (window.matchMedia("(max-width: 768px)").matches) {
                return el.classList.toggle('collapsed');
              }
            }, false);
          });
          WidthChange = function(mq) {
            if (mq.matches) {
              if (el.classList.contains('collapsed')) {
                el.classList.remove('collapsed');
              }
            } else {
              if (!el.classList.contains('collapsed')) {
                el.classList.add('collapsed');
              }
            }
          };
          if (matchMedia) {
            mq = window.matchMedia("(min-width: 769px)");
            mq.addListener(WidthChange);
            return WidthChange(mq);
          }
        }
      })(document.querySelector('#tok3nSidebarMenu'));
    };

    /*
    My phonelines
     */
    countrySelect = gebi("countrySelect");
    countryCode = gebi("countryCode");
    phoneNumber = gebi('phoneNumber');
    selectCountryCode = function(el) {
      var countryCodeValue;
      countryCodeValue = el.options[el.selectedIndex].value;
      return countryCode.innerHTML = "+" + countryCodeValue;
    };
    toggleNextButton = function(el) {
      var button, parentEl;
      parentEl = findClosestAncestor(el, "tok3n-dashboard-form-lower-wrapper");
      button = parentEl.nextSibling.querySelector('.tok3n-dashboard-main-button');
      if (el.checkValidity() || !isEmptyOrDefault(el)) {
        return button.disabled = false;
      } else {
        return button.disabled = true;
      }
    };
    toggleNextButtonOtp = function(el) {
      var button, parentEl;
      parentEl = findClosestAncestor(el, "tok3n-dashboard-new-form");
      button = parentEl.querySelector('.tok3n-dashboard-main-button');
      if (hasFormValidation()) {
        if (el.checkValidity() && el.value.length === 6) {
          return button.disabled = false;
        } else {
          return button.disabled = true;
        }
      } else {
        if (el.value.length === 6) {
          return button.disabled = false;
        } else {
          return button.disabled = true;
        }
      }
    };
    limitToSixChar = function() {
      if (this.value.length > 6) {
        return this.value = this.value.slice(0, 6);
      }
    };
    exports.phonelineNew1 = function() {
      selectCountryCode(countrySelect);
      phoneNumber.addEventListener("keyup", function(evt) {
        return toggleNextButton(evt.target);
      });
      return countrySelect.addEventListener('change', function(evt) {
        return selectCountryCode(evt.target);
      });
    };
    exports.phonelineNew2 = function() {
      var signupOtpInput;
      signupOtpInput = gebi('tok3nOtpInput');
      signupOtpInput.addEventListener('keyup', function(evt) {
        return toggleNextButtonOtp(evt.target);
      });
      return signupOtpInput.addEventListener("input", limitToSixChar);
    };

    /*
    My applications
     */
    exports.applications = function() {
      var cardsContainer;
      cardsContainer = qs('.tok3n-cards-container');
      if (cardsContainer) {
        Tok3nDashboard.masonry = new Masonry(cardsContainer, {
          itemSelector: '.card',
          gutter: '.grid-gutter'
        });
      }
      forEach(cardsContainer.querySelectorAll('.front'), function(el) {
        return el.addEventListener('click', function() {
          var card;
          findClosestAncestor(el, 'flipper').classList.add('flipped');
          card = [].filter.call(el.parentNode.children, function(gl) {
            return gl.classList.contains('back');
          });
          return forEach(card, function(fl) {
            return fl.style.zIndex = 3;
          });
        }, false);
      });
      return forEach(cardsContainer.querySelectorAll('.flip'), function(el) {
        return el.addEventListener('click', function() {
          return findClosestAncestor(el, 'flipper').classList.remove('flipped');
        }, false);
      });
    };

    /*
    My integrations
     */
    exports.integrationView = function() {
      var toggleEl;
      toggleEl = qsa('.toggle-secret');
      if (toggleEl != null) {
        forEach(toggleEl, function(el) {
          return el.addEventListener('click', function(ev) {
            var hiddenEl;
            ev.preventDefault();
            hiddenEl = [].filter.call(el.parentNode.children, function(gl) {
              return gl.classList.contains('secret');
            });
            if (hiddenEl != null) {
              return forEach(hiddenEl, function(fl) {
                if (fl.classList.contains('hidden')) {
                  el.innerHTML = 'hide';
                  return fl.classList.remove('hidden');
                } else if (!fl.classList.contains('hidden')) {
                  el.innerHTML = 'show';
                  return fl.classList.add('hidden');
                }
              });
            }
          }, false);
        });
      }
      return (function(arr) {
        var el, _i, _len, _results;
        if (arr) {
          _results = [];
          for (_i = 0, _len = arr.length; _i < _len; _i++) {
            el = arr[_i];
            _results.push(el.addEventListener('click', function() {
              var child, _j, _len1, _ref, _results1;
              _ref = el.children;
              _results1 = [];
              for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
                child = _ref[_j];
                if (child.classList.contains('dropdown-menu')) {
                  _results1.push(child.classList.toggle('dropdown-show'));
                } else {
                  _results1.push(void 0);
                }
              }
              return _results1;
            }, false));
          }
          return _results;
        }
      })(document.querySelectorAll('.dropdown'));
    };
    exports.integrationNew = function() {
      var callbackField, newIntegrationRadio;
      newIntegrationRadio = querySelectorAll('.tok3n-new-integration-kind-radio, .tok3n-new-integration-kind-radio input');
      callbackField = qs('.tok3n-new-integration-callback-url');
      return newIntegrationRadio.forEach(function(el) {
        return el.addEventListener('click', function(evt) {
          evt.stopPropagation();
          if (evt.target.classList.contains('tok3n-new-integration-kind-radio-web')) {
            evt.preventDefault();
            evt.target.querySelector('input').checked = true;
            return callbackField.classList.remove('collapsed');
          } else if (evt.target.classList.contains('tok3n-new-integration-kind-radio-general')) {
            evt.preventDefault();
            evt.target.querySelector('input').checked = true;
            return callbackField.classList.add('collapsed');
          } else {
            if (evt.target.id === 'newIntegrationKindWeb') {
              return callbackField.classList.remove('collapsed');
            } else if (evt.target.id === 'newIntegrationKindGeneral') {
              return callbackField.classList.add('collapsed');
            }
          }
        }, false);
      });
    };

    /*
    Settings
     */
    toggleVerifyPassword = function() {
      var passwordField, verifyPassword;
      passwordField = qs("input.tok3n-user-password");
      verifyPassword = qs('.tok3n-user-verify-password');
      if (passwordField) {
        if (passwordField.value) {
          return verifyPassword.classList.remove("collapsed");
        } else {
          return verifyPassword.classList.add("collapsed");
        }
      }
    };
    return exports.settings = function() {
      toggleVerifyPassword();
      return document.querySelector('.tok3n-user-password').addEventListener('keyup', function(event) {
        return toggleVerifyPassword();
      }, false);
    };
  });
})();
