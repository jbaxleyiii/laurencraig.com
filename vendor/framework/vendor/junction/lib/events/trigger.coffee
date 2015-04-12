###

  Trigger an event on each of the DOM elements in the current set.

  @param {string} event The event(s) to trigger.
  @param {object} args Arguments to append to callback invocations.
  @return junction
  @this junction

###
junction.fn.trigger = (event, args) ->

  evts = event.split(" ")

  @each ->

    for evnt in evts

      split = evnt.split "."
      evt = split[0]

      namespace = (if split.length > 0 then split[1] else null)

      if evt is "click"

        if this.tagName is "INPUT" and this.type is "checkbox" and this.click

          this.click()
          return false

      if document.createEvent

        event = document.createEvent "Event"

        event.initEvent evt, true, true
        event._args = args
        event._namespace = namespace

        this.dispatchEvent event

      else if document.createEventObject

        if ("" + this[evt]).indexOf("function") > -1
          this.ssEventTrigger =
            _namespace: namespace
            _args: args

          this[evt]()
        else
          document.documentElement[evt] =
            el: this
            _namespace: namespace
            _args: args
