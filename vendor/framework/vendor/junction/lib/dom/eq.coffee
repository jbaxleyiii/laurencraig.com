
###

  Returns the indexed element wrapped in a new `junction` object.

  @param {integer} index The index of the element to wrap and return.
  @return junction
  @this junction

###

junction.fn.eq = (index) ->

  if this[index]
    return junction(this[index])

  junction []
