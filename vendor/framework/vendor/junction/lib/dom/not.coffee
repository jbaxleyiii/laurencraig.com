###

  Removes elements from the current set.

  @param {string} selector The selector to use when removing the elements.
  @return junction
  @this junction

###

junction.fn.not = (selector) ->

  returns = []

  @each ->

    found = junction selector, this.parentNode

    if junction.inArray(this, found) is -1
      returns.push this

    return

  junction returns
