###

  Remove an attribute from each element in the current set.

  @param {string} name The name of the attribute.
  @return junction
  @this junction

###
junction.fn.removeAttr = (name) ->

  @each ->

    this.removeAttribute name
    return
