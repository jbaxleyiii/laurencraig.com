
###

  Get all of the sibling elements for each element in the current set.

  @return junction
  @this junction

###
junction.fn.siblings = ->

  if !@length
    return junction []

  siblings = []

  el = this[0].parentNode.firstChild

  loop
    if el.nodeType is 1 and el isnt this[0]
      siblings.push el

    el = el.nextSibling

    break if !el

  junction siblings
