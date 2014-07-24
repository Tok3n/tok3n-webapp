(function() {
  return namespace('Tok3nDashboard.Screens', function(exports) {

    /*
    Sitewide utils
     */
    var addNewParsleyForm, buttonFilePathCompletion, cardsContainer, countryCode, countrySelect, destroyButtonFilePathCompletion, destroyMasonry, destroyParsleyForm, destroyPreventedLinks, dropdownList, evtPreventDefault, flipCardToBack, flipCardToFront, initPreventedLinks, limitToSixChar, newIntegrationRadio, passwordField, phoneNumber, selectCountryCode, showHideCallback, toggleNextButton, toggleNextButtonOtp, toggleSecret, toggleVerifyPassword, verifyPassword, verifyPasswordField;
    evtPreventDefault = function(evt) {
      return evt.preventDefault();
    };
    initPreventedLinks = function() {
      querySelectorAll('a[href="#"]').forEach(function(el) {
        el.addEventListener('click', evtPreventDefault);
        return Tok3nDashboard.CurrentPreventedLinks.push(el);
      });
      return devConsoleLog("Inited current prevented links");
    };
    destroyPreventedLinks = function() {
      return setTimeout(function() {
        if (Tok3nDashboard.PreviousPreventedLinks.length) {
          Tok3nDashboard.PreviousPreventedLinks.forEach(function(el) {
            return el.removeEventListener('click', evtPreventDefault);
          });
          devConsoleLog("Destroyed previous prevented links");
        }
        Tok3nDashboard.PreviousPreventedLinks = Tok3nDashboard.CurrentPreventedLinks;
        return Tok3nDashboard.CurrentPreventedLinks = [];
      }, Tok3nDashboard.slidingAnimationDuration);
    };
    addNewParsleyForm = function(formElement, submitForm, clsHandler) {
      var form, submit;
      form = $(formElement);
      submit = qs(submitForm);
      form.parsley({
        classHandler: clsHandler
      });
      Tok3nDashboard.formEventHandler = function(evt) {
        var formEvent;
        form.parsley().validate();
        formEvent = new CustomEvent('submitValidatedForm', {
          detail: {
            validatedForm: form[0],
            isValid: form.parsley().isValid()
          }
        });
        return window.dispatchEvent(formEvent);
      };
      submit.addEventListener('click', Tok3nDashboard.formEventHandler);
      if (Tok3nDashboard.Environment.isDevelopment) {
        return console.log("Added validated form " + formElement);
      }
    };
    destroyParsleyForm = function(formElement, submitForm, clsHandler) {
      var form, submit;
      form = $(formElement);
      submit = qs(submitForm);
      form.parsley().destroy();
      submit.removeEventListener('click', Tok3nDashboard.formEventHandler);
      if (Tok3nDashboard.Environment.isDevelopment) {
        return console.log("Destroyed validated form " + formElement);
      }
    };

    /*
    Sitewide
     */
    exports.sitewide = function() {
      var current;
      current = capitaliseFirstLetter(Tok3nDashboard.initWindow);
      document.getElementById("tok3n" + current).classList.add('tok3n-pt-page-current');
      document.getElementById("tok3n" + current + "MenuButton").classList.add('tok3n-sidebar-selected');
      return (function(el) {
        var WidthChange, menuItems, mq;
        if (el) {
          document.querySelector('#collapseSidebarButton').addEventListener('click', function() {
            return el.classList.toggle('collapsed');
          });
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
    exports.initEveryTime = function() {
      return initPreventedLinks();
    };
    exports.destroyEveryTime = function() {
      return destroyPreventedLinks();
    };

    /*
    My devices
     */
    exports.deviceNew3 = function() {
      return addNewParsleyForm('#deviceNew3Form', '#deviceNew3Submit', '#deviceNew3Form');
    };
    exports.destroyDeviceNew3 = function() {
      return destroyParsleyForm('#deviceNew3Form', '#deviceNew3Submit', '#deviceNew3Form');
    };

    /*
    My phonelines
     */
    countrySelect = gebi("phonelineNew1CountrySelect");
    countryCode = gebi("phonelineNew1CountryCode");
    phoneNumber = gebi('phonelineNew1PhoneNumber');
    selectCountryCode = function(evt) {
      var countryCodeValue, el;
      el = evt.target;
      countryCodeValue = el.options[el.selectedIndex].value;
      return countryCode.innerHTML = "+" + countryCodeValue;
    };
    toggleNextButton = function(evt) {
      var button, el, parentEl;
      el = evt.target;
      parentEl = findClosestAncestor(el, "tok3n-dashboard-form-lower-wrapper");
      button = parentEl.nextSibling.querySelector('.tok3n-dashboard-main-button');
      if (el.checkValidity() || !isEmptyOrDefault(el)) {
        return button.disabled = false;
      } else {
        return button.disabled = true;
      }
    };
    toggleNextButtonOtp = function(evt) {
      var button, el, parentEl;
      el = evt.target;
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
      phoneNumber.addEventListener("keyup", toggleNextButton);
      return countrySelect.addEventListener('change', selectCountryCode);
    };
    exports.destroyPhonelineNew1 = function() {
      phoneNumber.removeEventListener("keyup", toggleNextButton);
      return countrySelect.addEventListener('change', selectCountryCode);
    };
    exports.phonelineNew2 = function() {
      var signupOtpInput;
      signupOtpInput = gebi('phonelineNew2OtpInput');
      signupOtpInput.addEventListener('keyup', toggleNextButtonOtp);
      return signupOtpInput.addEventListener("input", limitToSixChar);
    };
    exports.destroyPhonelineNew2 = function() {
      return signupOtpInput.removeEventListener('keyup', toggleNextButtonOtp);
    };
    exports.phonelineNew3 = function() {
      return addNewParsleyForm('#tok3nPhonelineNew3Form', '#tok3nPhonelineNew3Submit', '#tok3nPhonelineNew3Form');
    };
    exports.destroyPhonelineNew3 = function() {
      return destroyParsleyForm('#tok3nPhonelineNew3Form', '#tok3nPhonelineNew3Submit', '#tok3nPhonelineNew3Form');
    };

    /*
    My applications
     */
    cardsContainer = qs('.tok3n-cards-container');
    flipCardToBack = function(evt) {
      var card, el;
      el = evt.target;
      findClosestAncestor(el, 'flipper').classList.add('flipped');
      card = [].filter.call(el.parentNode.children, function(gl) {
        return gl.classList.contains('back');
      });
      return forEach(card, function(fl) {
        return fl.style.zIndex = 3;
      });
    };
    flipCardToFront = function(evt) {
      return findClosestAncestor(evt.target, 'flipper').classList.remove('flipped');
    };
    exports.applications = function() {
      if (cardsContainer) {
        Tok3nDashboard.masonry = new Masonry(cardsContainer, {
          itemSelector: '.card',
          gutter: '.grid-gutter'
        });
      }
      forEach(cardsContainer.querySelectorAll('.front'), function(el) {
        return el.addEventListener('click', flipCardToBack);
      });
      return forEach(cardsContainer.querySelectorAll('.flip'), function(el) {
        return el.addEventListener('click', flipCardToFront);
      });
    };
    destroyMasonry = function() {
      if (Tok3nDashboard.masonry) {
        if (Tok3nDashboard.masonry.isResizeBound) {
          Tok3nDashboard.masonry.destroy();
          if (Tok3nDashboard.Environment.isDevelopment) {
            return console.log('Destroyed masonry.');
          }
        }
      }
    };
    exports.destroyApplications = function() {
      destroyMasonry();
      forEach(cardsContainer.querySelectorAll('.front'), function(el) {
        return el.removeEventListener('click', flipCardToBack);
      });
      return forEach(cardsContainer.querySelectorAll('.flip'), function(el) {
        return el.removeEventListener('click', flipCardToFront);
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
            if (Tok3nDashboard.Environment.isDevelopment) {
              console.log(data);
            }
            options = {
              title: "Request types",
              pieHole: 0.4
            };
            chart = new google.visualization.PieChart(document.getElementById("donutChart"));
            return chart.draw(data, options);
          };
          drawChartDataRequestHistory = function(e) {
            var chart, data, options;
            data = google.visualization.arrayToDataTable(eval_(e.detail));
            if (Tok3nDashboard.Environment.isDevelopment) {
              console.log(data);
            }
            options = {
              title: "Requests"
            };
            chart = new google.visualization.LineChart(document.getElementById("requestHistoryChart"));
            return chart.draw(data, options);
          };
          drawChartDataUsersHistory = function(e) {
            var chart, data, options;
            data = google.visualization.arrayToDataTable(eval_(e.detail));
            if (Tok3nDashboard.Environment.isDevelopment) {
              console.log(data);
            }
            options = {
              title: "Users"
            };
            chart = new google.visualization.LineChart(document.getElementById("usersHistoryChart"));
            return chart.draw(data, options);
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
          return;
          if (namespaceExists(google, 'visualization')) {
            return google.visualization.events.addListener(chart, "ready", function() {
              if (Tok3nDashboard.compatibilityLayout) {
                return Tok3nDashboard.resizeContent();
              }
            });
          }
        });
      };
      if (Tok3nDashboard.Jsapi.isLoaded) {
        return attachChartFunctions();
      } else {
        return ee.addListener('tok3nJsapiPromiseCreated', attachChartFunctions);
      }
    };
    toggleSecret = function(ev) {
      var el, hiddenEl;
      el = ev.target;
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
    };
    dropdownList = function(ev) {
      var child, _i, _len, _ref, _results;
      _ref = ev.target.children;
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
    };
    exports.integrationView = function() {
      var dropdowns, toggleEl;
      toggleEl = querySelectorAll('.toggle-secret');
      if (toggleEl) {
        toggleEl.forEach(function(el) {
          return el.addEventListener('click', toggleSecret);
        });
      }
      dropdowns = querySelectorAll('.dropdown');
      if (dropdowns) {
        return dropdowns.forEach(function(el) {
          return el.addEventListener('click', dropdownList);
        });
      }
    };
    exports.destroyIntegrationView = function() {
      var dropdowns, toggleEl;
      toggleEl = querySelectorAll('.toggle-secret');
      if (toggleEl) {
        toggleEl.forEach(function(el) {
          return el.removeEventListener('click', toggleSecret);
        });
      }
      dropdowns = querySelectorAll('.dropdown');
      if (dropdowns) {
        return dropdowns.forEach(function(el) {
          return el.removeEventListener('click', dropdownList);
        });
      }
    };
    buttonFilePathCompletion = function() {
      $(document).on("change", ".btn-file :file", function() {
        var input, label, numFiles, pattern;
        input = $(this);
        numFiles = (input.get(0).files ? input.get(0).files.length : 1);
        pattern = /\\/g;
        label = input.val().replace(pattern, "/").replace(/.*\//, "");
        input.trigger("fileselect", [numFiles, label]);
      });
      return $(".btn-file :file").on("fileselect", function(event, numFiles, label) {
        var input, log;
        input = $(this).parents(".input-group").find(":text");
        log = (numFiles > 1 ? numFiles + " files selected" : label);
        if (input.length) {
          input.val(log);
        } else {
          if (log) {
            alert(log);
          }
        }
      });
    };
    destroyButtonFilePathCompletion = function() {
      $(document).off("change", ".btn-file :file");
      return $(".btn-file :file").off("fileselect");
    };
    showHideCallback = function(evt) {
      var callbackField, callbackInput, hideCallback, showCallback;
      callbackField = qs('.tok3n-new-integration-callback-url');
      callbackInput = gebi('integrationNewCallbackUrl');
      showCallback = function() {
        callbackField.classList.remove('collapsed');
        return callbackInput.setAttribute('data-parsley-required', 'true');
      };
      hideCallback = function() {
        callbackField.classList.add('collapsed');
        return callbackInput.setAttribute('data-parsley-required', 'false');
      };
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
        if (evt.target.id === 'integrationNewKindWeb') {
          return showCallback();
        } else if (evt.target.id === 'integrationNewKindGeneral') {
          return hideCallback();
        }
      }
    };
    newIntegrationRadio = querySelectorAll('.tok3n-new-integration-kind-radio, .tok3n-new-integration-kind-radio input');
    exports.integrationNew = function() {
      newIntegrationRadio.forEach(function(el) {
        return el.addEventListener('click', showHideCallback);
      });
      buttonFilePathCompletion();
      return addNewParsleyForm('#integrationNewForm', '#integrationNewSubmit', '#integrationNewForm');
    };
    exports.destroyIntegrationNew = function() {
      newIntegrationRadio.forEach(function(el) {
        return el.removeEventListener('click', showHideCallback);
      });
      destroyButtonFilePathCompletion();
      return destrayParsleyForm('#integrationNewForm', '#integrationNewSubmit', '#integrationNewForm');
    };
    exports.integrationEdit = function() {
      addNewParsleyForm('#integrationEditForm', '#integrationEditSubmit', '#integrationEditForm');
      return buttonFilePathCompletion();
    };
    exports.destroyIntegrationEdit = function() {
      destroyParsleyForm('#integrationEditForm', '#integrationEditSubmit', '#integrationEditForm');
      return destroyButtonFilePathCompletion();
    };

    /*
    Settings
     */
    passwordField = gebi('tok3nUserPassword');
    verifyPassword = qs('.tok3n-user-verify-password');
    verifyPasswordField = gebi('tok3nUserVerifyPassword');
    toggleVerifyPassword = function() {
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
    exports.settings = function() {
      toggleVerifyPassword();
      passwordField.addEventListener('keyup', toggleVerifyPassword);
      return addNewParsleyForm('#tok3nSettingsForm', '#tok3nSettingsSubmit', '#tok3nSettingsForm');
    };
    return exports.destroySettings = function() {
      passwordField.removeEventListener('keyup', toggleVerifyPassword);
      return destroyParsleyForm('#tok3nSettingsForm', '#tok3nSettingsSubmit', '#tok3nSettingsForm');
    };
  });
})();
