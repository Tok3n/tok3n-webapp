(function() {
  BasicTipTests('with Tourist.Tip.Bootstrap', function() {
    return new Tourist.Tip.Bootstrap({
      model: this.model
    });
  });

  BasicTourTests('with Tourist.Tip.Bootstrap', function() {
    return new Tourist.Tour({
      stepOptions: this.options,
      steps: this.steps,
      cancelStep: this.finalQuit,
      successStep: this.finalSucceed,
      tipClass: 'Bootstrap'
    });
  });

  describe("Tourist.Tip.Bootstrap", function() {
    beforeEach(function() {
      loadFixtures('tour.html');
      this.model = new Tourist.Model();
      return this.s = new Tourist.Tip.Bootstrap({
        model: this.model
      });
    });
    afterEach(function() {
      return this.s.destroy();
    });
    describe('hide/show', function() {
      it('slidein effect runs', function() {
        var el;
        spyOn(Tourist.Tip.Bootstrap.effects, 'slidein').andCallThrough();
        this.s.options.showEffect = 'slidein';
        el = $('#target-one');
        this.s.tip.setPosition(el, 'top center', 'bottom center');
        this.s.show();
        return expect(Tourist.Tip.Bootstrap.effects.slidein).toHaveBeenCalled();
      });
      it('show works with an effect', function() {
        Tourist.Tip.Bootstrap.effects.showeff = jasmine.createSpy();
        this.s.options.showEffect = 'showeff';
        this.s.show();
        return expect(Tourist.Tip.Bootstrap.effects.showeff).toHaveBeenCalled();
      });
      return it('hide works with an effect', function() {
        Tourist.Tip.Bootstrap.effects.hideeff = jasmine.createSpy();
        this.s.options.hideEffect = 'hideeff';
        this.s.hide();
        return expect(Tourist.Tip.Bootstrap.effects.hideeff).toHaveBeenCalled();
      });
    });
    return describe('setTarget', function() {
      return it('setPosition will not show the tip', function() {
        var el;
        el = $('#target-one');
        this.s.tip.setPosition(el, 'top center', 'bottom center');
        spyOn(this.s.tip, '_setPosition');
        this.s.setTarget([10, 20], {});
        return expect(this.s.tip._setPosition).toHaveBeenCalledWith([10, 20], 'top center', 'bottom center');
      });
    });
  });

  describe("Tourist.Tip.BootstrapTip", function() {
    beforeEach(function() {
      loadFixtures('tour.html');
      return this.s = new Tourist.Tip.BootstrapTip();
    });
    afterEach(function() {
      return this.s.destroy();
    });
    describe('hide/show', function() {
      it('initially hidden', function() {
        return expect(this.s.el).toHide();
      });
      it('hide works', function() {
        this.s.show();
        this.s.hide();
        return expect(this.s.el).toHide();
      });
      return it('show works', function() {
        this.s.show();
        return expect(this.s.el).toShow();
      });
    });
    return describe('positioning', function() {
      it('setPosition will not show the tip', function() {
        var el;
        expect(this.s.el).toHide();
        el = $('#target-one');
        this.s.setPosition(el, 'top center', 'bottom center');
        return expect(this.s.el).toHide();
      });
      it('setPosition keeps the tip shown', function() {
        var el;
        this.s.show();
        el = $('#target-one');
        this.s.setPosition(el, 'top center', 'bottom center');
        return expect(this.s.el).toShow();
      });
      return it('setPosition handles an absolute point', function() {
        this.s.show();
        this.s.setPosition([20, 30], 'top left', null);
        expect(this.s.el.css('top')).toEqual('40px');
        return expect(this.s.el.css('left')).toEqual('10px');
      });
    });
  });

}).call(this);
