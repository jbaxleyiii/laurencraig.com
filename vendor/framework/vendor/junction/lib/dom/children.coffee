
###

  Get the children of the current collection.
  @return junction
  @this junction

###
junction.fn.children = ->

  returns = []

  @each ->
    children = this.children
    i = -1

    while i++ < children.length - 1
      if junction.inArray(children[i], returns) is -1
        returns.push children[i]

  return junction returns
