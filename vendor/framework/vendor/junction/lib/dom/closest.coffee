
###

  Find an element matching the selector in the
  set of the current element and its parents.

  @param {string} selector The selector used to identify the target element.
  @return junction
  @this junction

###
junction.fn.closest = (selector) ->

  returns = []

  if not selector
    return junction returns

  @each ->

    element = undefined
    $self = junction(element = this)

    if $self.is(selector)
      returns.push this
      return

    while element.parentElement
      if junction(element.parentElement).is(selector)
        returns.push element.parentElement
        break

      element = element.parentElement

    return

  junction returns
