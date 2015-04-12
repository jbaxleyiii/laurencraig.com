
###

  Clone and return the current set of nodes into a
  new `junction` object.

  @return junction
  @this junction

###
junction.fn.clone = ->
  returns = []
  @each ->
    returns.push @cloneNode(true)
    return

  junction returns
