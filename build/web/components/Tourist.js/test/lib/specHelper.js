(function() {
  jasmine.getFixtures().fixturesPath = 'test/fixtures';

  jasmine.getStyleFixtures().fixturesPath = 'test/fixtures';

  beforeEach(function() {
    return this.addMatchers({
      toShow: function(exp) {
        var actual;
        actual = this.actual;
        return actual.css('display') !== 'none';
      },
      toHide: function(exp) {
        var actual;
        actual = this.actual;
        return actual.css('display') === 'none';
      }
    });
  });

}).call(this);
