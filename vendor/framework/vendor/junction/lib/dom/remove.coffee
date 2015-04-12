###

  Remove the current set of elements from the DOM.

  @return junction
  @this junction

###
junction.fn.remove = ->

  @each ->

    if this.parentNode
      this.parentNode.removeChild this

    return
