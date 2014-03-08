(function() {
  window.BasicTourTests = function(description, tourGenerator) {
    return describe("Tourist.Tour " + description, function() {
      beforeEach(function() {
        loadFixtures('tour.html');
        this.options = {
          "this": 1,
          that: 34
        };
        this.steps = [
          {
            content: '<p class="one">One</p>',
            target: $('#target-one'),
            highlightTarget: true,
            closeButton: true,
            nextButton: true,
            setup: function(tour, options) {},
            teardown: function() {}
          }, {
            content: '<p class="two">Step Two</p>',
            closeButton: true,
            skipButton: true,
            setup: function() {
              return {
                target: $('#target-two')
              };
            },
            teardown: function() {}
          }, {
            content: '<p class="three action">Step Three</p>',
            closeButton: true,
            nextButton: true,
            setup: function() {},
            teardown: function() {}
          }
        ];
        this.finalQuit = {
          content: '<p class="finalquit">The user quit early</p>',
          okButton: true,
          target: $('#target-one'),
          setup: function() {},
          teardown: function() {}
        };
        this.finalSucceed = {
          content: '<p class="finalsuccess">User made it all the way through</p>',
          okButton: true,
          target: $('#target-one'),
          setup: function() {},
          teardown: function() {}
        };
        return this.s = tourGenerator.call(this);
      });
      afterEach(function() {
        return Tourist.Tip.Base.destroy();
      });
      describe('basics', function() {
        return it('inits', function() {
          expect(this.s.model instanceof Tourist.Model).toEqual(true);
          return expect(this.s.view instanceof Tourist.Tip[this.s.options.tipClass]).toEqual(true);
        });
      });
      describe('rendering', function() {
        return it('starts and updates the view', function() {
          var el;
          this.s.start();
          this.s.next();
          this.s.next();
          el = this.s.view._getTipElement();
          expect(el.find('.action')).toExist();
          expect(el.find('.action-label')).toExist();
          return expect(el.find('.action-label').text()).toEqual('Do this:');
        });
      });
      describe('zIndex parameter', function() {
        it('uses specified z-index', function() {
          var el;
          this.steps[0].zIndex = 4000;
          this.s.start();
          el = this.s.view._getTipElement();
          return expect(el.attr('style')).toContain('z-index: 4000');
        });
        return it('clears z-index when not specified', function() {
          var el;
          this.steps[0].zIndex = 4000;
          this.s.start();
          this.s.next();
          el = this.s.view._getTipElement();
          return expect(el.attr('style')).not.toContain('z-index: 4000');
        });
      });
      describe('stepping', function() {
        it('starts and updates the model', function() {
          expect(this.s.model.get('current_step')).toEqual(null);
          this.s.start();
          expect(this.s.model.get('current_step')).not.toEqual(null);
          return expect(this.s.model.get('current_step').index).toEqual(0);
        });
        it('starts and updates the view', function() {
          var el;
          this.s.start();
          el = this.s.view._getTipElement();
          expect(el).toShow();
          expect(el.find('.one')).toExist();
          expect(el.find('.two')).not.toExist();
          return expect(el.find('.tour-counter').text()).toEqual('step 1 of 3');
        });
        it('calls setup', function() {
          spyOn(this.steps[0], 'setup');
          this.s.start();
          return expect(this.steps[0].setup).toHaveBeenCalledWith(this.s, this.options);
        });
        it('calls teardown', function() {
          spyOn(this.steps[0], 'teardown');
          spyOn(this.steps[1], 'setup');
          this.s.start();
          this.s.next();
          expect(this.steps[0].teardown).toHaveBeenCalledWith(this.s, this.options);
          return expect(this.steps[1].setup).toHaveBeenCalledWith(this.s, this.options);
        });
        it('moves to the next step', function() {
          var el;
          this.s.start();
          this.s.next();
          expect(this.s.model.get('current_step').index).toEqual(1);
          el = this.s.view._getTipElement();
          expect(el).toShow();
          expect(el.find('.one')).not.toExist();
          return expect(el.find('.two')).toExist();
        });
        it('calls the final step when through all steps', function() {
          var el;
          this.s.start();
          this.s.next();
          this.s.next();
          expect(this.s.model.get('current_step').final).toEqual(false);
          this.s.next();
          expect(this.s.model.get('current_step').index).toEqual(3);
          expect(this.s.model.get('current_step').final).toEqual(true);
          el = this.s.view._getTipElement();
          expect(el).toShow();
          expect(el.find('.three')).not.toExist();
          return expect(el.find('.finalsuccess')).toExist();
        });
        it('last step is final when no successStep', function() {
          this.s.options.successStep = null;
          this.s.start();
          this.s.next();
          this.s.next();
          expect(this.s.model.get('current_step').index).toEqual(2);
          return expect(this.s.model.get('current_step').final).toEqual(true);
        });
        it('calls the function when successStep is just a function', function() {
          var callback;
          callback = jasmine.createSpy();
          this.s.options.successStep = callback;
          this.s.start();
          this.s.next();
          this.s.next();
          this.s.next();
          return expect(callback).toHaveBeenCalled();
        });
        it('stops after the final step', function() {
          var el;
          this.s.start();
          this.s.next();
          this.s.next();
          this.s.next();
          this.s.next();
          expect(this.s.model.get('current_step')).toEqual(null);
          return el = this.s.view._getTipElement();
        });
        it('targets an element returned from setup', function() {
          this.s.start();
          this.s.next();
          return expect(this.s.view.target[0]).toEqual($('#target-two')[0]);
        });
        return it('highlights and unhighlights when neccessary', function() {
          this.s.start();
          expect($('#target-one')).toHaveClass('tour-highlight');
          this.s.next();
          expect($('#target-two')).not.toHaveClass('tour-highlight');
          return expect($('#target-one')).not.toHaveClass('tour-highlight');
        });
      });
      describe('stop()', function() {
        it('pops final cancel step when I pass it true', function() {
          var el;
          this.s.start();
          this.s.next();
          this.s.stop(true);
          expect(this.s.model.get('current_step').final).toEqual(true);
          el = this.s.view._getTipElement();
          return expect(el.find('.finalquit')).toExist();
        });
        it('actually stops when I pass falsy value', function() {
          this.s.start();
          this.s.next();
          this.s.stop();
          return expect(this.s.model.get('current_step')).toEqual(null);
        });
        it('unhighlights current thing', function() {
          this.s.start();
          this.s.stop();
          expect(this.s.model.get('current_step')).toEqual(null);
          return expect($('#target-one')).not.toHaveClass('tour-highlight');
        });
        it('called when final step open will really stop', function() {
          this.s.start();
          this.s.next();
          this.s.stop(true);
          this.s.stop(true);
          return expect(this.s.model.get('current_step')).toEqual(null);
        });
        it('handles case when no final step', function() {
          this.s.options.cancelStep = null;
          this.s.start();
          this.s.next();
          this.s.stop(true);
          return expect(this.s.model.get('current_step')).toEqual(null);
        });
        it('calls teardown on step before final', function() {
          spyOn(this.steps[1], 'teardown');
          spyOn(this.finalQuit, 'setup');
          this.s.start();
          this.s.next();
          this.s.stop(true);
          expect(this.steps[1].teardown).toHaveBeenCalledWith(this.s, this.options);
          return expect(this.finalQuit.setup).toHaveBeenCalledWith(this.s, this.options);
        });
        return it('calls teardown on final', function() {
          spyOn(this.finalQuit, 'teardown');
          this.s.start();
          this.s.next();
          this.s.stop(true);
          this.s.stop(true);
          return expect(this.finalQuit.teardown).toHaveBeenCalledWith(this.s, this.options);
        });
      });
      describe('interaction with view buttons', function() {
        it('handles next button', function() {
          this.s.start();
          this.s.view.onClickNext({});
          return expect(this.s.model.get('current_step').index).toEqual(1);
        });
        return it('handles close button', function() {
          this.s.start();
          this.s.view.onClickClose({});
          expect(this.s.model.get('current_step').final).toEqual(true);
          this.s.view.onClickClose({});
          return expect(this.s.model.get('current_step')).toEqual(null);
        });
      });
      return describe('events', function() {
        it('emits a start event', function() {
          var spy;
          spy = jasmine.createSpy();
          this.s.bind('start', spy);
          this.s.start();
          return expect(spy).toHaveBeenCalled();
        });
        return it('emits a stop event', function() {
          var spy;
          spy = jasmine.createSpy();
          this.s.bind('stop', spy);
          this.s.start();
          this.s.next();
          this.s.stop(false);
          return expect(spy).toHaveBeenCalled();
        });
      });
    });
  };

  BasicTourTests('with Tourist.Tip.Simple', function() {
    return new Tourist.Tour({
      stepOptions: this.options,
      steps: this.steps,
      cancelStep: this.finalQuit,
      successStep: this.finalSucceed,
      tipClass: 'Simple'
    });
  });

}).call(this);
