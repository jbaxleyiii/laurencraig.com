
junction.state.ready = false
junction.readyQueue = []

###

  Bind callbacks to be run with the DOM is "ready"

  @param {function} fn The callback to be run
  @return junction
  @this junction

###


junction.ready = (fn) ->

  if junction.ready and fn
    fn.call document

  else if fn
    junction.readyQueue.push fn

  else
    junction.runReady()

  return [document]


junction.fn.ready = (fn) ->
  junction.ready fn

  return @


junction.runReady = ->

  if not junction.state.ready
    while junction.readyQueue.length
      junction.readyQueue.shift().call document

    junction.state.ready = true



###

  If DOM is already ready at exec time, depends on the browser.
  From:
  https://github.com/mobify/mobifyjs/blob/
  526841be5509e28fc949038021799e4223479f8d/src/capture.js#L128

###


if (
  if document.attachEvent then document.readyState is "complete"
  else document.readyState isnt "loading"
)

  junction.runReady()

else

  if !window.document.addEventListener
    window.document.attachEvent "DOMContentLoaded", junction.runReady
    window.document.attachEvent "onreadystatechange", junction.runReady
  else
    window.document
      .addEventListener "DOMContentLoaded", junction.runReady, false
    window.document
      .addEventListener "onreadystatechange", junction.runReady, false

  window.addEventListener "load", junction.runReady, false
