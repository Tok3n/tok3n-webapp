(function() {
  BasicTipTests('with Tourist.Tip.QTip', function() {
    return new Tourist.Tip.QTip({
      model: this.model
    });
  });

  BasicTourTests('with Tourist.Tip.QTip', function() {
    return new Tourist.Tour({
      stepOptions: this.options,
      steps: this.steps,
      cancelStep: this.finalQuit,
      successStep: this.finalSucceed,
      tipClass: 'QTip'
    });
  });

  describe("Tourist.Tip.QTip specific", function() {
    beforeEach(function() {
      loadFixtures('tour.html');
      this.model = new Tourist.Model({
        current_step: null
      });
      return this.s = new Tourist.Tip.QTip({
        model: this.model
      });
    });
    afterEach(function() {
      return Tourist.Tip.Base.destroy();
    });
    return describe('setTarget()', function() {
      return it('will set the @target', function() {
        var el, target;
        el = $('#target-one');
        this.s.setTarget(el, {});
        target = this.s.qtip.get('position.target');
        return expect(target).toEqual(el);
      });
    });
  });

}).call(this);
