
###

  Gets the height value of the first element or
  sets the height for the whole set.

  @param {float|undefined} value The value to assign.
  @return junction
  @this junction

###
junction.fn.height = (value) ->
  junction._dimension this, "height", value
