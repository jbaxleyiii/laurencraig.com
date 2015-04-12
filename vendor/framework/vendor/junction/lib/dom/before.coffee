
###

  Insert an element or HTML string before each
  element in the current set.

  @param {string|HTMLElement} fragment The HTML or HTMLElement to insert.
  @return junction
  @this junction

###
junction.fn.before = (fragment) ->

  if typeof (fragment) is "string" or fragment.nodeType isnt `undefined`

    fragment = junction(fragment)

  @each (index) ->

    for piece in fragment
      insertEl = (if index > 0 then piece.cloneNode(true) else piece)

      this.parentNode.insertBefore insertEl, this

      return
