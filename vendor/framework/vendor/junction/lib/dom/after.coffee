
###

  Insert an element or HTML string after each element in the current set.

  @param {string|HTMLElement} fragment The HTML or HTMLElement to insert.
  @return junction
  @this junction

###
junction.fn.after = (fragment) ->

  if typeof(fragment) is "string" or fragment.nodeType isnt undefined
    fragment = junction fragment

  if fragment.length > 1
    fragment = fragment.reverse()

  @each (index) ->
    for piece in fragment
      insertEl = (if index > 0 then piece.cloneNode(true) else piece)

      this.parentNode.insertBefore insertEl, this.nextSibling

      return
