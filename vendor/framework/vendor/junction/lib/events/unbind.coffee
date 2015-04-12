###

  Unbind a previous bound callback for an event.

  @param {string} event The event(s) the callback was bound to..
  @param {function} callback Callback to unbind.
  @return junction
  @this junction

###

junction.fn.unbind = (event, callback) ->

  unbind = (e, namespace, cb) ->
    matched = []
    bound = this.junctionData.events[e]

    if !bound.length
      return

    for bnd in bound

      if !namespace or namespace is bnd.namespace

        if cb is undefined or cb is bnd.originalCallback

          if window["removeEventListener"]

            this.removeEventListener e, bnd.callback, false

          else if this.detachEvent

            this.detachEvent "on#{e}", bnd.callback

            if (bound.length is 1 and
              this.junctionData.loop and
              this.junctionData.loop[e]
            )

              document.documentElement
                .detachEvent(
                  "onpropertychange"
                  this.junctionData.loop[e]
                )

          matched.push bound.indexOf bnd

      return

    for match in matched
      this.junctionData.events[e].splice matched.indexOf(match), 1


  unbindAll = (namespace, cb) ->

    for evtKey of this.junctionData.events
      unbind.call this, evtKey, namespace, cb
    return
  

  evts = (if event then event.split(" ") else [])

  @each ->

    if !this.junctionData or !this.junctionData.events
      return

    if !evts.length
      unbindAll.call this
    else

      for evnt in evts
        split = evnt.split "."
        evt = split[0]

        namespace = (if split.length > 0 then split[1] else null)

        if evt
          unbind.call this, evt, namespace, callback
        else
          unbindAll.call this, namespace, callback



junction.fn.off = junction.fn.unbind
