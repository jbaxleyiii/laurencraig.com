
###

  Bind a callback to an event for the currrent
  set of elements, unbind after one occurence.

  @param {string} event The event(s) to watch for.
  @param {function} callback Callback to invoke on the event.
  @return junction
  @this junction

###
junction.fn.one = (event, callback) ->

  evts = event.split(" ")

  @each ->
    cbs = {}
    $t = junction this

    for thisevt in evts

      cbs[thisevt] = (e) ->

        $t = junction this

        for j of cbs
          $t.unbind j, cbs[j]

        return callback.apply this, [e].concat(e._args)

      $t.bind thisevt, cbs[thisevt]

      return
