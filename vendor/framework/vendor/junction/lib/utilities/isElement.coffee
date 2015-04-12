
junction.isElement = (el) ->

  (
    if typeof HTMLElement is "object"
        el instanceof HTMLElement
    else el and
    typeof el is "object" and
    el isnt null and
    el.nodeType is 1 and
    typeof el.nodeName is "string"
  )
