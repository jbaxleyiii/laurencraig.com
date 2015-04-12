
###

  Bind a callback to an event for the currrent set of elements.

  @param {string} evt The event(s) to watch for.
  @param {object,function} data Data to be included
    with each event or the callback.
  @param {function} originalCallback Callback to be
    invoked when data is define.d.
  @return junction
  @this junction

###



junction.fn.bind = (evt, data, originalCallback) ->


  initEventCache = (el, evt) ->

    if !el.junctionData
      el.junctionData = {}

    if !el.junctionData.events
      el.junctionData.events = {}

    if !el.junctionData.loop
      el.junctionData.loop = {}

    if !el.junctionData.events[evt]
      el.junctionData.events[evt] = []


  addToEventCache = (el, evt, eventInfo) ->

    obj = {}

    obj.isCustomEvent = eventInfo.isCustomEvent
    obj.callback = eventInfo.callfunc
    obj.originalCallback = eventInfo.originalCallback
    obj.namespace = eventInfo.namespace

    el.junctionData.events[evt].push obj

    if eventInfo.customEventLoop
      el.junctionData.loop[evt] = eventInfo.customEventLoop


  if typeof data is "function"
    originalCallback = data
    data = null

  evts = evt.split(" ")
  docEl = document.documentElement

  # NOTE the `triggeredElement` is purely for custom events from IE
  encasedCallback = (e, namespace, triggeredElement) ->

    if e._namespace and e._namespace isnt namespace
      return

    e.data = data
    e.namespace = e._namespace

    returnTrue = ->
      true

    e.isDefaultPrevented = ->
      false

    originalPreventDefault = e.preventDefault

    preventDefaultConstructor = ->
      if originalPreventDefault

        ->
          e.isDefaultPrevented = returnTrue
          originalPreventDefault.call e
          return

      else

        ->
          e.isDefaultPrevented = returnTrue
          e.returnValue = false
          return


    # thanks https://github.com/jonathantneal/EventListener
    e.target = triggeredElement or e.target or e.srcElement
    e.preventDefault = preventDefaultConstructor()
    e.stopPropagation = e.stopPropagation or ->
      e.cancelBubble = true
      return

    result = originalCallback.apply(this, [e].concat(e._args))

    if !result
      e.preventDefault()
      e.stopPropagation()

    return result


  return @each ->

    oEl = this

    for evnt in evts

      split = evnt.split "."

      evt = split[0]

      namespace = (if split.length > 0 then split[1] else null)

      domEventCallback = (originalEvent) ->

        if oEl.ssEventTrigger

          originalEvent._namespace = oEl.ssEventTrigger._namespace
          originalEvent._args = oEl.ssEventTrigger._args
          oEl.ssEventTrigger = null

        return encasedCallback.call oEl, originalEvent, namespace



      customEventCallback = null
      customEventLoop = null

      initEventCache this, evt

      if "addEventListener" of this
        this.addEventListener evt, domEventCallback, false

      else if this.attachEvent

        if this["on" + evt] isnt undefined
          this.attachEvent "on" + evt, domEventCallback


      evnObj =
        callfunc: customEventCallback or domEventCallback
        isCustomEvent: !!customEventCallback
        customEventLoop: customEventLoop
        originalCallback: originalCallback
        namespace: namespace

      addToEventCache this, evt, evnObj

      return


junction.fn.on = junction.fn.bind
