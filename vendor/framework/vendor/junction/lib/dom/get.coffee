
###

  Returns the raw DOM node at the passed index.

  @param {integer} index The index of the element to wrap and return.
  @return HTMLElement
  @this junction

###

junction.fn.get = (index) ->
  return @[index]
