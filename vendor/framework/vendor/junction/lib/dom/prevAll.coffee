###

  Returns a `junction` object with the set of *all*
  siblings before each element in the original set.

  @return junction
  @this junction

###
junction.fn.prevAll = ->

  returns = []

  @each ->
    $previous = junction(this).prev()

    while $previous.length
      returns.push $previous[0]
      $previous = $previous.prev()
    return

  junction returns
