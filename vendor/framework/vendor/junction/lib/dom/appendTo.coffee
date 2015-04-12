
###

  Insert the current set as the last child of the elements
  matching the selector.

  @param {string} selector The selector after which to append the current set.
  @return junction
  @this junction

###
junction.fn.appendTo = (selector) ->

  @each ->

    junction(selector).append this
    return
