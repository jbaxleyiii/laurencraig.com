
###

  Insert the current set after the elements matching the selector.

  @param {string} selector The selector after which to insert the current set.
  @return junction
  @this junction

###
junction.fn.insertAfter = (selector) ->
  @each ->
    junction(selector).after this
    return
