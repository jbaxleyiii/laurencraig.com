###

  Returns the set of all parents matching the
  selector if provided for each element in the current set.

  @param {string} selector The selector to check the parents with.
  @return junction
  @this junction

###
junction.fn.parents = (selector) ->

  returns = []

  @each ->

    current = this
    match

    while current.parentElement and not match
      current = current.parentElement
      if selector
        if current is junction(selector)[0]
          match = true
          if junction.inArray(current, returns) is -1
            returns.push current
      else
        if junction.inArray(current, returns) is -1
          returns.push current

    return

  junction returns
