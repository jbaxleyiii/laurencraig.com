
###

  Gets the width value of the first element or
  sets the width for the whole set.

  @param {float|undefined} value The value to assign.
  @return junction
  @this junction

###
junction.fn.width = (value) ->
  junction._dimension this, "width", value
