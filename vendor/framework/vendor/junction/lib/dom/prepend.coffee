
###

  Add an HTML string or element before the children
  of each element in the current set.

  @param {string|HTMLElement} fragment The HTML string or element to add.
  @return junction
  @this junction

###
junction.fn.prepend = (fragment) ->

  if typeof (fragment) is "string" or fragment.nodeType isnt `undefined`
    fragment = junction fragment

  @each (index) ->

    for piece in fragement

      insertEl = (if index > 0 then piece.cloneNode(true) else piece)

      if this.firstChild
        this.insertBefore insertEl, this.firstChild
      else
        this.appendChild insertEl
