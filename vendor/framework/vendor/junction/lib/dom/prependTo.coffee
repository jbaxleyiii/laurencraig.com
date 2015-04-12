###

  Add each element of the current set before the
  children of the selected elements.

  @param {string} selector The selector for the elements to add the current set to..
  @return junction
  @this junction

###
junction.fn.prependTo = (selector) ->

  @each ->
    junction(selector).prepend this
    return
