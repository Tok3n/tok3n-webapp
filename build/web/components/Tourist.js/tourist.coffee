window.Tourist = window.Tourist or {}

###
A model for the Tour. We'll only use the 'current_step' property.
###
class Tourist.Model extends Backbone.Model
  _module: 'Tourist'

# Just the tip, just to see how it feels.
window.Tourist.Tip = window.Tourist.Tip or {}


###
The flyout showing the content of each step.

This is the base class containing most of the logic. Can extend for different
tooltip implementations.
###
class Tourist.Tip.Base
  _module: 'Tourist'
  _.extend @prototype, Backbone.Events

  # You can override any of thsee templates for your own stuff
  skipButtonTemplate: '<button class="btn btn-xs pull-right tour-next">Skip this step →</button>'
  nextButtonTemplate: '<button class="btn btn-primary btn-xs pull-right tour-next">Next step →</button>'
  finalButtonTemplate: '<button class="btn btn-primary btn-xs pull-right tour-next">Finish up</button>'

  closeButtonTemplate: '<a class="btn btn-close tour-close" href="#"><i class="icon icon-remove"></i></a>'
  okButtonTemplate: '<button class="btn btn-xs tour-close btn-primary">Okay</button>'

  actionLabelTemplate: _.template '<h4 class="action-label"><%= label %></h4>'
  actionLabels: ['Do this:', 'Then this:', 'Next this:']

  highlightClass: 'tour-highlight'

  template: _.template '''
    <div>
      <div class="tour-container">
        <%= close_button %>
        <%= content %>
        <p class="tour-counter <%= counter_class %>"><%= counter%></p>
      </div>
      <div class="tour-buttons">
        <%= buttons %>
      </div>
    </div>
  '''

  # options -
  #   model - a Tourist.Model object
  constructor: (@options={}) ->
    @el = $('<div/>')

    @initialize(options)

    @_bindClickEvents()

    Tourist.Tip.Base._cacheTip(this)

  destroy: ->
    @el.remove()

  # Render the current step as specified by the Tour Model
  #
  # step - step object
  #
  # Return this
  render: (step) ->
    @hide()

    if step
      @_setTarget(step.target or false, step)
      @_setZIndex('')
      @_renderContent(step, @_buildContentElement(step))
      @show() if step.target
      @_setZIndex(step.zIndex, step) if step.zIndex

    this

  # Show the tip
  show: ->
    # Override me

  # Hide the tip
  hide: ->
    # Override me

  # Set the element which the tip will point to
  #
  # targetElement - a jquery element
  # step - step object
  setTarget: (targetElement, step) ->
    @_setTarget(targetElement, step)

  # Unhighlight and unset the current target
  cleanupCurrentTarget: ->
    @target.removeClass(@highlightClass) if @target and @target.removeClass
    @target = null

  ###
  Event Handlers
  ###

  # User clicked close or ok button
  onClickClose: (event) =>
    @trigger('click:close', this, event)
    false

  # User clicked next or skip button
  onClickNext: (event) =>
    @trigger('click:next', this, event)
    false


  ###
  Private
  ###

  # Returns the jquery element that contains all the tip data.
  _getTipElement: ->
    # Override me

  # Place content into your tip's body. Called in render()
  #
  # step - the step object for the current step
  # contentElement - a jquery element containing all the tip's content
  #
  # Returns nothing
  _renderContent: (step, contentElement) ->
    # Override me

  # Bind to the buttons
  _bindClickEvents: ->
    el = @_getTipElement()
    el.delegate('.tour-close', 'click', @onClickClose)
    el.delegate('.tour-next', 'click', @onClickNext)

  # Set the current target
  #
  # target - a jquery element that this flyout should point to.
  # step - step object
  #
  # Return nothing
  _setTarget: (target, step) ->
    @cleanupCurrentTarget()
    target.addClass(@highlightClass) if target and step and step.highlightTarget
    @target = target

  # Set z-index on the tip element.
  #
  # zIndex - the z-index desired; falsy val will clear it.
  _setZIndex: (zIndex) ->
    el = @_getTipElement()
    el.css('z-index', zIndex or '')

  # Will build the element that has all the content for the current step
  #
  # step - the step object for the current step
  #
  # Returns a jquery object with all the content.
  _buildContentElement: (step) ->
    buttons = @_buildButtons(step)

    content = $($.parseHTML(@template(
      content: step.content
      buttons: buttons
      close_button: @_buildCloseButton(step)
      counter: if step.final then '' else "step #{step.index+1} of #{step.total}"
      counter_class: if step.final then 'final' else ''
    )))
    content.find('.tour-buttons').addClass('no-buttons') unless buttons

    @_renderActionLabels(content)

    content

  # Create buttons based on step options.
  #
  # Returns a string of button html to be placed into the template.
  _buildButtons: (step) ->
    buttons = ''

    buttons += @okButtonTemplate if step.okButton
    buttons += @skipButtonTemplate if step.skipButton

    if step.nextButton
      buttons += if step.final then @finalButtonTemplate else @nextButtonTemplate

    buttons

  _buildCloseButton: (step) ->
    if step.closeButton then @closeButtonTemplate else ''

  _renderActionLabels: (el) ->
    actions = el.find('.action')
    actionIndex = 0
    for action in actions
      label = $($.parseHTML(@actionLabelTemplate(label: @actionLabels[actionIndex])))
      label.insertBefore(action)
      actionIndex++

  # Caches this tip for destroying it later.
  @_cacheTip: (tip) ->
    Tourist.Tip.Base._cachedTips = [] unless Tourist.Tip.Base._cachedTips
    Tourist.Tip.Base._cachedTips.push(tip)

  # Destroy all tips. Useful in tests.
  @destroy: ->
    return unless Tourist.Tip.Base._cachedTips
    for tip in Tourist.Tip.Base._cachedTips
      tip.destroy()
    Tourist.Tip.Base._cachedTips = null


###
Bootstrap based tip implementation
###
class Tourist.Tip.Bootstrap extends Tourist.Tip.Base

  initialize: (options) ->
    defs =
      showEffect: null
      hideEffect: null
    @options = _.extend(defs, options)
    @tip = new Tourist.Tip.BootstrapTip()

  destroy: ->
    @tip.destroy()
    super()

  # Show the tip
  show: ->
    if @options.showEffect
      fn = Tourist.Tip.Bootstrap.effects[@options.showEffect]
      fn.call(this, @tip, @tip.el)
    else
      @tip.show()

  # Hide the tip
  hide: ->
    if @options.hideEffect
      fn = Tourist.Tip.Bootstrap.effects[@options.hideEffect]
      fn.call(this, @tip, @tip.el)
    else
      @tip.hide()


  ###
  Private
  ###

  # Overridden to get the bootstrap element
  _getTipElement: ->
    @tip.el

  # Set the current target. Overridden to set the target on the tip.
  #
  # target - a jquery element that this flyout should point to.
  # step - step object
  #
  # Return nothing
  _setTarget: (target, step) ->
    super(target, step)
    @tip.setTarget(target)

  # Jam the content into the tip's body. Also place the tip along side the
  # target element.
  _renderContent: (step, contentElement) ->
    my = step.my or 'left center'
    at = step.at or 'right center'

    @tip.setContainer(step.container or $('body'))
    @tip.setContent(contentElement)
    @tip.setPosition(step.target or false, my, at)


# One can add more effects by hanging a function from this object, then using
# it in the tipOptions.hideEffect or showEffect. i.e.
#
# @s = new Tourist.Tip.Bootstrap
#   model: m
#   showEffect: 'slidein'
#
Tourist.Tip.Bootstrap.effects =

  # Move tip away from target 80px, then slide it in.
  slidein: (tip, element) ->
    OFFSETS = top: 80, left: 80, right: -80, bottom: -80

    # this is a 'Corner' object. Will give us a top, bottom, etc
    side = tip.my.split(' ')[0]
    side = side or 'top'

    # figure out where to start the animation from
    offset = OFFSETS[side]

    # side must be top or left.
    side = 'top' if side == 'bottom'
    side = 'left' if side == 'right'

    value = parseInt(element.css(side))

    # stop the previous animation
    element.stop()

    # set initial position
    css = {}
    css[side] = value + offset
    element.css(css)
    element.show()

    css[side] = value

    # if they have jquery ui, then use a fancy easing. Otherwise, use a builtin.
    easings = ['easeOutCubic', 'swing', 'linear']
    for easing in easings
      break if $.easing[easing]

    element.animate(css, 300, easing)
    null


###
Simple implementation of tooltip with bootstrap markup.

Almost entirely deals with positioning. Uses the similar method for
positioning as qtip2:

  my: 'top center'
  at: 'bottom center'

###
class Tourist.Tip.BootstrapTip

  template: '''
    <div class="popover">
      <div class="arrow"></div>
      <div class="popover-content"></div>
    </div>
  '''

  FLIP_POSITION:
    bottom: 'top'
    top: 'bottom'
    left: 'right'
    right: 'left'

  constructor: (options) ->
    defs =
      offset: 10
      tipOffset: 10
    @options = _.extend(defs, options)
    @el = $($.parseHTML(@template))
    @hide()

  destroy: ->
    @el.remove()

  show: ->
    @el.show().addClass('visible')

  hide: ->
    @el.hide().removeClass('visible')

  setTarget: (@target) ->
    @_setPosition(@target, @my, @at)

  setPosition: (@target, @my, @at) ->
    @_setPosition(@target, @my, @at)

  setContainer: (container) ->
    container.append(@el)

  setContent: (content) ->
    @_getContentElement().html(content)

  ###
  Private
  ###

  _getContentElement: ->
    @el.find('.popover-content')

  _getTipElement: ->
    @el.find('.arrow')

  # Sets the target and the relationship of the tip to the project.
  #
  # target - target node as a jquery element
  # my - position of the tip e.g. 'top center'
  # at - where to point to the target e.g. 'bottom center'
  _setPosition: (target, my='left center', at='right center') ->
    return unless target

    [clas, shift] = my.split(' ')

    originalDisplay = @el.css('display')

    @el
      .css({ top: 0, left: 0, margin: 0, display: 'block' })
      .removeClass('top').removeClass('bottom')
      .removeClass('left').removeClass('right')
      .addClass(@FLIP_POSITION[clas])

    return unless target

    # unset any old tip positioning
    tip = @_getTipElement().css
      left: ''
      right: ''
      top: ''
      bottom: ''

    if shift != 'center'
      tipOffset =
        left: tip[0].offsetWidth/2
        right: 0
        top: tip[0].offsetHeight/2
        bottom: 0

      css = {}
      css[shift] = tipOffset[shift] + @options.tipOffset
      css[@FLIP_POSITION[shift]] = 'auto'
      tip.css(css)

    targetPosition = @_caculateTargetPosition(at, target)
    tipPosition = @_caculateTipPosition(my, targetPosition)
    position = @_adjustForArrow(my, tipPosition)

    @el.css(position)

    # reset the display so we dont inadvertantly show the tip
    @el.css(display: originalDisplay)

  # Figure out where we need to point to on the target element.
  #
  # myPosition - position string on the target. e.g. 'top left'
  # target - target as a jquery element or an array of coords. i.e. [10,30]
  #
  # returns an object with top and left attrs
  _caculateTargetPosition: (atPosition, target) ->

    if Object.prototype.toString.call(target) == '[object Array]'
      return {left: target[0], top: target[1]}

    bounds = @_getTargetBounds(target)
    pos = @_lookupPosition(atPosition, bounds.width, bounds.height)

    return {
      left: bounds.left + pos[0]
      top: bounds.top + pos[1]
    }

  # Position the tip itself to be at the right place in relation to the
  # targetPosition.
  #
  # myPosition - position string for the tip. e.g. 'top left'
  # targetPosition - where to point to on the target element. e.g. {top: 20, left: 10}
  #
  # returns an object with top and left attrs
  _caculateTipPosition: (myPosition, targetPosition) ->
    width = @el[0].offsetWidth
    height = @el[0].offsetHeight
    pos = @_lookupPosition(myPosition, width, height)

    return {
      left: targetPosition.left - pos[0]
      top: targetPosition.top - pos[1]
    }

  # Just adjust the tip position to make way for the arrow.
  #
  # myPosition - position string for the tip. e.g. 'top left'
  # tipPosition - proper position for the whole tip. e.g. {top: 20, left: 10}
  #
  # returns an object with top and left attrs
  _adjustForArrow: (myPosition, tipPosition) ->
    [clas, shift] = myPosition.split(' ') # will be top, left, right, or bottom

    tip = @_getTipElement()
    width = tip[0].offsetWidth
    height = tip[0].offsetHeight

    position =
      top: tipPosition.top
      left: tipPosition.left

    # adjust the main direction
    switch clas
      when 'top'
        position.top += height+@options.offset
      when 'bottom'
        position.top -= height+@options.offset
      when 'left'
        position.left += width+@options.offset
      when 'right'
        position.left -= width+@options.offset

    # shift the tip
    switch shift
      when 'left'
        position.left -= width/2+@options.tipOffset
      when 'right'
        position.left += width/2+@options.tipOffset
      when 'top'
        position.top -= height/2+@options.tipOffset
      when 'bottom'
        position.top += height/2+@options.tipOffset

    position

  # Figure out how much to shift based on the position string
  #
  # position - position string like 'top left'
  # width - width of the thing
  # height - height of the thing
  #
  # returns a list: [left, top]
  _lookupPosition: (position, width, height) ->
    width2 = width/2
    height2 = height/2

    posLookup =
      'top left': [0,0]
      'left top': [0,0]
      'top right': [width,0]
      'right top': [width,0]
      'bottom left': [0,height]
      'left bottom': [0,height]
      'bottom right': [width,height]
      'right bottom': [width,height]

      'top center': [width2,0]
      'left center': [0,height2]
      'right center': [width,height2]
      'bottom center': [width2,height]

    posLookup[position]

  # Returns the boundaries of the target element
  #
  # target - a jquery element
  _getTargetBounds: (target) ->
    el = target[0]

    if typeof el.getBoundingClientRect == 'function'
      size = el.getBoundingClientRect()
    else
      size =
        width: el.offsetWidth
        height: el.offsetHeight

    $.extend({}, size, target.offset())



###
Qtip based tip implementation
###
class Tourist.Tip.QTip extends Tourist.Tip.Base

  TIP_WIDTH = 6
  TIP_HEIGHT = 14
  ADJUST = 10

  OFFSETS =
    top: 80
    left: 80
    right: -80
    bottom: -80

  # defaults for the qtip flyout.
  QTIP_DEFAULTS:
    content:
      text: '..'
    show:
      ready: false
      delay: 0
      effect: (qtip) ->
        el = $(this)

        # this is a 'Corner' object. Will give us a top, bottom, etc
        side = qtip.options.position.my
        side = side[side.precedance] if side
        side = side or 'top'

        # figure out where to start the animation from
        offset = OFFSETS[side]

        # side must be top or left.
        side = 'top' if side == 'bottom'
        side = 'left' if side == 'right'

        value = parseInt(el.css(side))

        # set initial position
        css = {}
        css[side] = value + offset
        el.css(css)
        el.show()

        css[side] = value
        el.animate(css, 300, 'easeOutCubic')
        null

      autofocus: false
    hide:
      event: null
      delay: 0
      effect: false
    position:
      # set target
      # set viewport to viewport
      adjust:
        method: 'shift shift'
        scroll: false
    style:
      classes: 'ui-tour-tip',
      tip:
        height: TIP_WIDTH,
        width: TIP_HEIGHT
    events: {}
    zindex: 2000

  # Options support everything qtip supports.
  initialize: (options) ->
    options = $.extend(true, {}, @QTIP_DEFAULTS, options)
    @el.qtip(options)
    @qtip = @el.qtip('api')
    @qtip.render()

  destroy: ->
    @qtip.destroy() if @qtip
    super()

  # Show the tip
  show: ->
    @qtip.show()

  # Hide the tip
  hide: ->
    @qtip.hide()


  ###
  Private
  ###

  # Overridden to get the qtip element
  _getTipElement: ->
    $('#qtip-'+@qtip.id)

  # Override to set the target on the qtip
  _setTarget: (targetElement, step) ->
    super(targetElement, step)
    @qtip.set('position.target', targetElement or false)

  # Jam the content into the qtip's body. Also place the tip along side the
  # target element.
  _renderContent: (step, contentElement) ->

    my = step.my or 'left center'
    at = step.at or 'right center'

    @_adjustPlacement(my, at)

    @qtip.set('content.text', contentElement)
    @qtip.set('position.container', step.container or $('body'))
    @qtip.set('position.my', my)
    @qtip.set('position.at', at)

    # viewport should be set before target.
    @qtip.set('position.viewport', step.viewport or false)
    @qtip.set('position.target', step.target or false)

    setTimeout( =>
      @_renderTipBackground(my.split(' ')[0])
    , 10)

  # Adjust the placement of the flyout based on its positioning relative to
  # the target. Tip placement and position adjustment is unhandled by qtip. It
  # does provide settings for adjustment, so we use those.
  #
  # my - string like 'top center'. Position of the tip on the flyout.
  # at - string like 'top center'. Place where the tip points on the target.
  #
  # Return nothing
  _adjustPlacement: (my, at) ->
    # issue is that when tip is on left, it needs to be taller than wide, but
    # when on top it should be wider than tall. We're accounting for this
    # here.

    if my.indexOf('top') == 0
      @_adjust(0, ADJUST)

    else if my.indexOf('bottom') == 0
      @_adjust(0, -ADJUST)

    else if my.indexOf('right') == 0
      @_adjust(-ADJUST, 0)

    else
      @_adjust(ADJUST, 0)

  # Set the qtip style properties for tip size and offset.
  _adjust: (adjustX, adjusty) ->
    @qtip.set('position.adjust.x', adjustX)
    @qtip.set('position.adjust.y', adjusty)

  # Add an icon for the tip. Their canvas tips suck. This way we can have a
  # shadow on the tip.
  #
  # direction - string like 'left', 'top', etc. Placement of the tip.
  #
  # Return Nothing
  _renderTipBackground: (direction) =>
    el = $('#qtip-'+@qtip.id+' .qtip-tip')
    bg = el.find('.qtip-tip-bg')
    unless bg.length
      bg = $('<div/>', {'class': 'icon icon-tip qtip-tip-bg'})
      el.append(bg)

    bg.removeClass('top left right bottom')
    bg.addClass(direction)



###
Simplest implementation of a tooltip. Used in the tests. Useful as an example
as well.
###
class Tourist.Tip.Simple extends Tourist.Tip.Base
  initialize: (options) ->
    $('body').append(@el)

  # Show the tip
  show: ->
    @el.show()

  # Hide the tip
  hide: ->
    @el.hide()

  _getTipElement: ->
    @el

  # Jam the content into our element
  _renderContent: (step, contentElement) ->
    @el.html(contentElement)
###

A way to make a tour. Basically, you specify a series of steps which explain
elements to point at and what to say. This class manages moving between those
steps.

The 'step object' is a simple js obj that specifies how the step will behave.

A simple Example of a step object:
  {
    content: '<p>Welcome to my step</p>'
    target: $('#something-to-point-at')
    closeButton: true
    highlightTarget: true
    setup: (tour, options) ->
      # do stuff in the interface/bind
    teardown: (tour, options) ->
      # remove stuff/unbind
  }

Basic Step object options:

  content - a string of html to put into the step.
  target - jquery object or absolute point: [10, 30]
  highlightTarget - optional bool, true will outline the target with a bright color.
  container - optional jquery element that should contain the step flyout.
              default: $('body')
  viewport - optional jquery element that the step flyout should stay within.
             $(window) is commonly used. default: false

  my - string position of the pointer on the tip. default: 'left center'
  at - string position on the element the tip points to. default: 'right center'
  see http://craigsworks.com/projects/qtip2/docs/position/#basics

Step object button options:

  okButton - optional bool, true will show a red ok button
  closeButton - optional bool, true will show a grey close button
  skipButton - optional bool, true will show a grey skip button
  nextButton - optional bool, true will show a red next button

Step object function options:

  All functions on the step will have the signature '(tour, options) ->'

    tour - the Draw.Tour object. Handy to call tour.next()
    options - the step options. An object passed into the tour when created.
              It has the environment that the fns can use to manipulate the
              interface, bind to events, etc. The same object is passed to all
              of a step object's functions, so it is handy for passing data
              between steps.

  setup - called before step is shown. Use to scroll to your target, hide/show things, ...

    'this' is the step object itself.

    MUST return an object. Properties in the returned object will override
    properties in the step object.

    i.e. the target might be dynamic so you would specify:

    setup: (tour, options) ->
      return { target: $('#point-to-me') }

  teardown - function called right before hiding the step. Use to unbind from
    things you bound to in setup().

    'this' is the step object itself.

    Return nothing.

  bind - an array of function names to bind. Use this for event handlers you use in setup().

    Will bind functions to the step object as this, and the first 2 args as tour and options.

    i.e.

    bind: ['onChangeSomething']
    setup: (tour, options) ->
      options.document.bind('change:something', @onChangeSomething)
    onChangeSomething: (tour, options, model, value) ->
      tour.next()
    teardown: (tour, options) ->
      options.document.unbind('change:something', @onChangeSomething)

###
class Tourist.Tour
  _.extend(@prototype, Backbone.Events)

  # options - tour options
  #   stepOptions - an object of options to be passed to each function called on a step object
  #   tipClass - the class from the Tourist.Tip namespace to use
  #   tipOptions - an object passed to the tip
  #   steps - array of step objects
  #   cancelStep - step object for a step that runs if hit the close button.
  #   successStep - step object for a step that runs last when they make it all the way through.
  constructor: (@options={}) ->
    defs =
      tipClass: 'Bootstrap'
    @options = _.extend(defs, @options)

    @model = new Tourist.Model
      current_step: null

    # there is only one tooltip. It will rerender for each step
    tipOptions = _.extend({model: @model}, @options.tipOptions)
    @view = new Tourist.Tip[@options.tipClass](tipOptions)

    @view.bind('click:close', _.bind(@stop, this, true))
    @view.bind('click:next', @next)

    @model.bind('change:current_step', @onChangeCurrentStep)


  ###
  Public
  ###

  # Starts the tour
  #
  # Return nothing
  start: ->
    @trigger('start', this)
    @next()

  # Resets the data and runs the final step
  #
  # doFinalStep - bool whether or not you want to run the final step
  #
  # Return nothing
  stop: (doFinalStep) ->
    if doFinalStep
      @_showCancelFinalStep()
    else
      @_stop()

  # Move to the next step
  #
  # Return nothing
  next: =>
    currentStep = @_teardownCurrentStep()

    index = 0
    index = currentStep.index+1 if currentStep

    if index < @options.steps.length
      @_showStep(@options.steps[index], index)
    else if index == @options.steps.length
      @_showSuccessFinalStep()
    else
      @_stop()

  # Set the stepOptions which is basically like the state for the tour.
  setStepOptions: (stepOptions) ->
    @options.stepOptions = stepOptions


  ###
  Handlers
  ###

  # Called when the current step changes on the model.
  onChangeCurrentStep: (model, step) =>
    @view.render(step)

  ###
  Private
  ###

  # Show the cancel final step - they closed it at some point.
  #
  # Return nothing
  _showCancelFinalStep: ->
    @_showFinalStep(false)

  # Show the success final step - they made it all the way through.
  #
  # Return nothing
  _showSuccessFinalStep: ->
    @_showFinalStep(true)

  # Teardown the current step.
  #
  # Returns the current step after teardown
  _teardownCurrentStep: ->
    currentStep = @model.get('current_step')
    @_teardownStep(currentStep)
    currentStep

  # Stop the tour and reset the state.
  #
  # Return nothing
  _stop: ->
    @_teardownCurrentStep()
    @model.set(current_step: null)
    @trigger('stop', this)

  # Shows a final step.
  #
  # success - bool whether or not to show the success final step. False shows
  #   the cancel final step.
  #
  # Return nothing
  _showFinalStep: (success) ->

    currentStep = @_teardownCurrentStep()

    finalStep = if success then @options.successStep else @options.cancelStep

    if _.isFunction(finalStep)
      finalStep.call(this, this, @options.stepOptions)
      finalStep = null

    return @_stop() unless finalStep
    return @_stop() if currentStep and currentStep.final

    finalStep.final = true
    @_showStep(finalStep, @options.steps.length)

  # Sets step to the current_step in our model. Does all the neccessary setup.
  #
  # step - a step object
  # index - int indexof the step 0 based.
  #
  # Return nothing
  _showStep: (step, index) ->
    return unless step

    step = _.clone(step)
    step.index = index
    step.total = @options.steps.length

    unless step.final
      step.final = (@options.steps.length == index+1 and not @options.successStep)

    # can pass dynamic options from setup
    step = _.extend(step, @_setupStep(step))

    @model.set(current_step: step)

  # Setup an arbitrary step
  #
  # step - a step object from @options.steps
  #
  # Returns the return value from step.setup. This will be an object with
  # properties that will override those in the current step object
  _setupStep: (step) ->
    return {} unless step and step.setup

    # bind to any handlers on the step object
    if step.bind
      for fn in step.bind
        step[fn] = _.bind(step[fn], step, this, @options.stepOptions)

    step.setup.call(step, this, @options.stepOptions) or {}

  # Teardown an arbitrary step
  #
  # step - a step object from @options.steps
  #
  # Return nothing
  _teardownStep: (step) ->
    step.teardown.call(step, this, @options.stepOptions) if step and step.teardown
    @view.cleanupCurrentTarget()
