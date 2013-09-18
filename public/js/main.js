// Generated by CoffeeScript 2.0.0-beta4
var delay, displayedFirstTour, drawChartDataDonut, drawChartDataRequestHistory, drawChartDataUsersHistory, ee, isFirstIntegration, submitOnFirstTour;
drawChartDataDonut = function (e) {
  var chart, data, options;
  data = google.visualization.arrayToDataTable([
    [
      'Task',
      'Requests'
    ],
    [
      'Valid',
      e.detail.ValidRequests
    ],
    [
      'Invalid',
      e.detail.InvalidRequests
    ],
    [
      'Pending',
      e.detail.IssuedRequests
    ]
  ]);
  options = {
    title: 'Request types',
    pieHole: .4
  };
  chart = new google.visualization.PieChart(document.getElementById('donutChart'));
  return chart.draw(data, options);
};
drawChartDataRequestHistory = function (e) {
  var chart, data, options;
  data = google.visualization.arrayToDataTable(eval_(e.detail));
  console.log(data);
  options = { title: 'Requests' };
  chart = new google.visualization.LineChart(document.getElementById('requestHistoryChart'));
  return chart.draw(data, options);
};
drawChartDataUsersHistory = function (e) {
  var chart, data, options;
  data = google.visualization.arrayToDataTable(eval_(e.detail));
  console.log(data);
  options = { title: 'Users' };
  chart = new google.visualization.LineChart(document.getElementById('usersHistoryChart'));
  return chart.draw(data, options);
};
google.load('visualization', '1', { packages: ['corechart'] });
window.addEventListener('drawChartDataDonut', drawChartDataDonut, false);
window.addEventListener('drawChartDataRequestHistory', drawChartDataRequestHistory, false);
window.addEventListener('drawChartDataUsersHistory', drawChartDataUsersHistory, false);
$(document).on('DOMMouseScroll mousewheel', '#list', function (ev) {
  var $this, delta, height, prevent, scrollHeight, scrollTop, up;
  $this = $(this);
  scrollTop = this.scrollTop;
  scrollHeight = this.scrollHeight;
  height = $this.height();
  delta = ev.type === 'DOMMouseScroll' ? ev.originalEvent.detail * -40 : ev.originalEvent.wheelDelta;
  up = delta > 0;
  prevent = function () {
    ev.stopPropagation();
    ev.preventDefault();
    ev.returnValue = false;
    return false;
  };
  if (!up && -delta > scrollHeight - height - scrollTop) {
    $this.scrollTop(scrollHeight);
    return prevent();
  } else if (up && delta > scrollTop) {
    $this.scrollTop(0);
    return prevent();
  }
});
ee = new EventEmitter;
delay = function (ms, func) {
  return setTimeout(func, ms);
};
isFirstIntegration = false;
displayedFirstTour = false;
submitOnFirstTour = false;
$(function () {
  var STEPS, SUCCESS, TOUR;
  STEPS = [
    {
      content: '<h4 class="title">Create your first integration</h4></div>' + '<p class="action">' + 'Click the <i>New integration</i> button in the left menu.' + '</p>',
      highlightTarget: true,
      my: 'left center',
      at: 'right center',
      target: $('#new-integration'),
      bind: ['onClick'],
      onClick: function (tour) {
        ee.once('addedIntegration', function () {
          tour.next();
          return true;
        });
        return false;
      },
      setup: function (tour, options) {
        $('#new-integration').on('click', this.onClick);
        return false;
      },
      teardown: function (tour, options) {
        $('#new-integration').off('click', this.onClick);
        return false;
      }
    },
    {
      content: '<h4 class="title">Hi there</h4>' + '<p class="action">' + 'Click the <i>New integration</i> button in the left menu.' + '</p>',
      highlightTarget: true,
      my: 'left bottom',
      at: 'right center',
      target: $('#popup-new-integration'),
      setup: function (tour, options) {
        ee.addListener('closedIntegrationWindow', function () {
          displayedFirstTour = true;
          tour.stop(false);
          return true;
        });
        ee.once('submitNewIntegration', function () {
          tour.next();
          return true;
        });
        return false;
      }
    }
  ];
  SUCCESS = {
    content: '<p>If you need to change something you can do it here.</p>',
    closeButton: true,
    nextButton: true,
    highlightTarget: true,
    my: 'left center',
    at: 'right center',
    target: $('#main .specs'),
    teardown: function (tour) {
      return displayedFirstTour = true;
    }
  };
  TOUR = new Tourist.Tour({
    tipClass: 'Bootstrap',
    steps: STEPS,
    successStep: SUCCESS,
    tipOptions: { showEffect: 'slidein' }
  });
  if (isFirstIntegration)
    return TOUR.start();
});
$(document).ready(function () {
  var radiobutton, secret, webtoggle;
  secret = $('.toggle-secret');
  secret.click(function () {
    $('.secret').toggle();
    if (secret.html() === 'show') {
      return secret.html('hide');
    } else {
      return secret.html('show');
    }
  });
  webtoggle = $('#popup-new-integration .web-toggle');
  radiobutton = $('#popup-new-integration input[type=radio]');
  radiobutton.click(function (e) {
    var value;
    value = $(e.currentTarget).val();
    if (value === 'web') {
      return webtoggle.slideDown();
    } else {
      return webtoggle.slideUp();
    }
  });
  $('.popup-trigger').magnificPopup({
    type: 'inline',
    callbacks: {
      open: function () {
        var self;
        self = this;
        if (!displayedFirstTour)
          ee.emitEvent('addedIntegration');
        $('.popover').hide();
        $('#popup-new-integration').submit(function (e) {
          submitOnFirstTour = true;
          e.preventDefault();
          return self.close();
        });
        return false;
      },
      beforeClose: function () {
        $('.popover').show();
        return false;
      },
      close: function () {
        if (submitOnFirstTour) {
          ee.emitEvent('submitNewIntegration');
        } else if (!displayedFirstTour) {
          ee.emitEvent('closedIntegrationWindow');
        }
        $('#popup-new-integration').unbind('submit');
        return false;
      }
    }
  });
  return $('#newImplementationAvatar').change(function () {
    var label;
    label = $(this).val().replace(/(\\)/g, '/').replace(/.*\//, '');
    return $('.avatar-path').attr('placeholder', label);
  });
});