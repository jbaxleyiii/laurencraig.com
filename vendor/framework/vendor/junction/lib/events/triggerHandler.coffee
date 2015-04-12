
###

  Trigger an event on the first element in the set,
  no bubbling, no defaults.

  @param {string} event The event(s) to trigger.
  @param {object} args Arguments to append to callback invocations.
  @return junction
  @this junction

###

junction.fn.triggerHandler = (event, args) ->
  e = event.split(" ")[0]
  el = this[0]
  ret - undefined

  if (document.createEvent and
    el.shoestringData and
    el.shoestringData.events and
    el.shoestringData.events[e]
  )

    bindings = el.shoestringData.events[e]

    for i of bindings

      if bindings.hasOwnProperty(i)
        event = document.createEvent("Event")
        event.initEvent e, true, true
        event._args = args
        args.unshift event

        ret = bindings[i].originalCallback.apply(event.target, args)
  ret
