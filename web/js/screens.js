(function() {
  Tok3nDashboard.Screens || (Tok3nDashboard.Screens = {});
  Tok3nDashboard.initWindow || (Tok3nDashboard.initWindow = 'Devices');
  return namespace('Tok3nDashboard.Screens', function(exports) {

    /*
    Sitewide
     */
    var addNewParsleyForm, countryCode, countrySelect, limitToSixChar, phoneNumber, selectCountryCode, toggleNextButton, toggleNextButtonOtp, toggleVerifyPassword;
    exports.sitewide = function() {
      var current;
      current = capitaliseFirstLetter(Tok3nDashboard.initWindow);
      document.getElementById("tok3n" + current).classList.add('tok3n-pt-page-current');
      document.getElementById("tok3n" + current + "MenuButton").classList.add('tok3n-sidebar-selected');
      querySelectorAll('a[href="#"]').forEach(function(el) {
        return el.addEventListener('click', function(evt) {
          return evt.preventDefault();
        }, false);
      });
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
    addNewParsleyForm = function(formElement, submitForm, clsHandler) {
      var form, submit;
      form = $(formElement);
      form.parsley({
        classHandler: clsHandler
      });
      Tok3nDashboard.ValidatedForms.push(form);
      submit = qs(submitForm);
      return submit.addEventListener('click', function(evt) {
        form.parsley().validate();
        if (Tok3nDashboard.Environment.isDevelopment) {
          return console.log(form.parsley().isValid());
        }
      }, false);
    };

    /*
    My devices
     */
    exports.deviceNew3 = function() {
      return addNewParsleyForm('#tok3nDeviceNew3Form', '#tok3nDeviceNew3Submit', '#tok3nDeviceNew3Form');
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
    exports.phonelineNew3 = function() {
      return addNewParsleyForm('#tok3nPhonelineNew3Form', '#tok3nPhonelineNew3Submit', '#tok3nPhonelineNew3Form');
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
    exports.integrationsCharts = function() {
      var attachChartFunctions;
      attachChartFunctions = function() {
        return Tok3nDashboard.Jsapi.isLoaded.then(function() {
          var chartEvent, drawChartDataDonut, drawChartDataRequestHistory, drawChartDataUsersHistory;
          drawChartDataDonut = function(e) {
            var chart, data, options;
            data = google.visualization.arrayToDataTable([["Task", "Requests"], ["Valid", e.detail.ValidRequests], ["Invalid", e.detail.InvalidRequests], ["Pending", e.detail.IssuedRequests]]);
            options = {
              title: "Request types",
              pieHole: 0.4
            };
            chart = new google.visualization.PieChart(document.getElementById("donutChart"));
            chart.draw(data, options);
            return google.visualization.events.addListener(chart, "ready", function() {
              return resizeContent();
            });
          };
          drawChartDataRequestHistory = function(e) {
            var chart, data, options;
            data = google.visualization.arrayToDataTable(eval_(e.detail));
            console.log(data);
            options = {
              title: "Requests"
            };
            chart = new google.visualization.LineChart(document.getElementById("requestHistoryChart"));
            chart.draw(data, options);
            return google.visualization.events.addListener(chart, "ready", function() {
              return resizeContent();
            });
          };
          drawChartDataUsersHistory = function(e) {
            var chart, data, options;
            data = google.visualization.arrayToDataTable(eval_(e.detail));
            console.log(data);
            options = {
              title: "Users"
            };
            chart = new google.visualization.LineChart(document.getElementById("usersHistoryChart"));
            chart.draw(data, options);
            return google.visualization.events.addListener(chart, "ready", function() {
              return resizeContent();
            });
          };
          window.addEventListener("drawChartDataDonut", drawChartDataDonut, false);
          window.addEventListener("drawChartDataRequestHistory", drawChartDataRequestHistory, false);
          window.addEventListener("drawChartDataUsersHistory", drawChartDataUsersHistory, false);
          Tok3nDashboard.Charts.areLoaded = true;
          if (Tok3nDashboard.Environment.isDevelopment) {
            console.log('Chart functions attached successfully.');
          }
          chartEvent = new CustomEvent('chartFunctionsLoaded');
          window.dispatchEvent(chartEvent);
        });
      };
      if (Tok3nDashboard.Jsapi.isLoaded) {
        return attachChartFunctions();
      } else {
        return ee.addListener('tok3nJsapiPromiseCreated', attachChartFunctions);
      }
    };
    exports.integrationView = function() {
      var dropdowns, toggleEl;
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
      dropdowns = querySelectorAll('.dropdown');
      if (dropdowns) {
        return dropdowns.forEach(function(el) {
          return el.addEventListener('click', function() {
            var child, _i, _len, _ref, _results;
            _ref = el.children;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              child = _ref[_i];
              if (child.classList.contains('dropdown-menu')) {
                _results.push(child.classList.toggle('dropdown-show'));
              } else {
                _results.push(void 0);
              }
            }
            return _results;
          }, false);
        });
      }
    };
    exports.integrationNew = function() {
      var callbackField, callbackInput, hideCallback, newIntegrationRadio, showCallback;
      newIntegrationRadio = querySelectorAll('.tok3n-new-integration-kind-radio, .tok3n-new-integration-kind-radio input');
      callbackField = qs('.tok3n-new-integration-callback-url');
      callbackInput = gebi('tokenIntegrationCallbackUrl');
      showCallback = function() {
        callbackField.classList.remove('collapsed');
        return callbackInput.setAttribute('data-parsley-required', 'true');
      };
      hideCallback = function() {
        callbackField.classList.add('collapsed');
        return callbackInput.setAttribute('data-parsley-required', 'false');
      };
      newIntegrationRadio.forEach(function(el) {
        return el.addEventListener('click', function(evt) {
          evt.stopPropagation();
          if (evt.target.classList.contains('tok3n-new-integration-kind-radio-web')) {
            evt.preventDefault();
            evt.target.querySelector('input').checked = true;
            return showCallback();
          } else if (evt.target.classList.contains('tok3n-new-integration-kind-radio-general')) {
            evt.preventDefault();
            evt.target.querySelector('input').checked = true;
            return hideCallback();
          } else {
            if (evt.target.id === 'newIntegrationKindWeb') {
              return showCallback();
            } else if (evt.target.id === 'newIntegrationKindGeneral') {
              return hideCallback();
            }
          }
        }, false);
      });
      return addNewParsleyForm('#tok3nIntegrationNewForm', '#tok3nIntegrationNewSubmit', '#tok3nIntegrationNewForm');
    };
    exports.integrationEdit = function() {
      return addNewParsleyForm('#tok3nIntegrationEditForm', '#tok3nIntegrationEditSubmit', '#tok3nIntegrationEditForm');
    };

    /*
    Settings
     */
    toggleVerifyPassword = function() {
      var passwordField, verifyPassword, verifyPasswordField;
      passwordField = qs("input.tok3n-user-password");
      verifyPassword = qs('.tok3n-user-verify-password');
      verifyPasswordField = gebi('tok3nUserVerifyPassword');
      if (passwordField) {
        if (passwordField.value) {
          verifyPassword.classList.remove("collapsed");
          return verifyPasswordField.setAttribute('data-parsley-required', 'true');
        } else {
          verifyPassword.classList.add("collapsed");
          return verifyPasswordField.setAttribute('data-parsley-required', 'false');
        }
      }
    };
    return exports.settings = function() {
      toggleVerifyPassword();
      document.querySelector('.tok3n-user-password').addEventListener('keyup', function(event) {
        return toggleVerifyPassword();
      }, false);
      return addNewParsleyForm('#tok3nSettingsForm', '#tok3nSettingsSubmit', '#tok3nSettingsForm');
    };
  });
})();
