
###

  Returns a `junction` object with the set of *one*
  sibling before each element in the original set.

  @return junction
  @this junction

###

junction.fn.prev = ->

  returns = []

  # TODO need to implement map
  @each ->

    # get the child nodes for this member of the set
    children = junction(@parentNode)[0].childNodes

    found = false

    for child, index in children by -1
      item = children.item[index]

      if found and item.nodeType is 1
        returns.push item

      if item is this
        found = true

      false

  junction returns
