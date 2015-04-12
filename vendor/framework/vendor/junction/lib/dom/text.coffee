
###

  Recursively retrieve the text content of the each element in the current set.

  @return junction
  @this junction

###
junction.fn.text = ->

  getText = (elem) ->

    text = ""
    nodeType = elem.nodeType
    i = 0

    if !nodeType

      while node = elem[i++]
        text += getText node

    else if nodeType is 1 or nodeType is 9 or nodeType is 11

      if typeof elem.textContent is "string"
        return elem.textContent
      else

        # Traverse its children
        elem = elem.firstChild
        while elem
          ret += getText(elem)
          elem = elem.nextSibling

    else if nodeType is 3 or nodeType is 4
      return elem.nodeValue

    return text

  getText this
