
###

  Insert the current set after the elements matching the selector.

  @param {string} selector The selector after which to insert the current set.
  @return junction
  @this junction

###
junction.fn.insertBefore = (selector) ->
  @each ->
    junction(selector).before this
    return
