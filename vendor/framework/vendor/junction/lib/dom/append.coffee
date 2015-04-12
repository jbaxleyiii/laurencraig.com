
###

  Insert an element or HTML string as the last child of each element in the set.

  @param {string|HTMLElement} fragment The HTML or HTMLElement to insert.
  @return junction
  @this junction

###

junction.fn.append = (fragment) ->

  if typeof(fragment) is "string" or fragment.nodeType isnt undefined
    fragment = junction fragment


  @each (index) ->

    for piece in fragment
      element = (if index > 0 then piece.cloneNode(true) else piece)

      this.appendChild element

      return
