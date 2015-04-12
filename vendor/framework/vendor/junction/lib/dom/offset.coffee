###

  Returns an object with the `top` and `left`
  properties corresponging to the first elements offsets.

  @return object
  @this junction

###
junction.fn.offset = ->
  top: this[0].offsetTop
  left: this[0].offsetLeft
