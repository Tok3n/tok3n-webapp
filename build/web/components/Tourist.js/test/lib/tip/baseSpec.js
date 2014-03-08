(function() {
  window.BasicTipTests = function(description, tipGenerator) {
    return describe("Tourist.Tip " + description, function() {
      beforeEach(function() {
        loadFixtures('tour.html');
        this.model = new Tourist.Model({
          current_step: null
        });
        return this.s = tipGenerator.call(this);
      });
      afterEach(function() {
        return Tourist.Tip.Base.destroy();
      });
      describe('basics', function() {
        return it('inits', function() {
          return expect(this.s.options.model instanceof Tourist.Model).toEqual(true);
        });
      });
      return describe('setTarget()', function() {
        it('will set the @target', function() {
          var el;
          el = $('#target-one');
          this.s.setTarget(el, {});
          return expect(this.s.target).toEqual(el);
        });
        it('will highlight the @target', function() {
          var el;
          el = $('#target-one');
          this.s.setTarget(el, {
            highlightTarget: true
          });
          return expect(el).toHaveClass(this.s.highlightClass);
        });
        return it('will highlight the @target', function() {
          var el;
          el = $('#target-one');
          this.s.setTarget(el, {
            highlightTarget: false
          });
          return expect(el).not.toHaveClass(this.s.highlightClass);
        });
      });
    });
  };

  BasicTipTests('with Tourist.Tip.Simple', function() {
    return new Tourist.Tip.Simple({
      model: this.model
    });
  });

}).call(this);
