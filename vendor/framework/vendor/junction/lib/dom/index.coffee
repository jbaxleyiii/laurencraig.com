

do ->

  _getIndex = (set, test) ->
    for item in set
      element = (if set.item then set.item(item) else item)

      if test(element)
        return result

      if element.nodeType is 1
        result++

    return -1

    ###

      Find the index in the current set for the passed
      selector. Without a selector it returns the
      index of the first node within the array of its siblings.

      @param {string|undefined} selector The selector used to search for the index.
      @return {integer}
      @this {junction}

    ###
    junction.fn.index = (selector) ->
      self = @

      # no arg? check the children,
      # otherwise check each element that matches
      if selector is `undefined`
        children = ((@[0] and @[0].parentNode) or document.documentElement).childNodes

        # check if the element matches the first of the set
        _getIndex children, (element) ->
          self[0] is element

      else

        # check if the element matches the first
        # selected node from the parent
        _getIndex self, (element) ->
          element is (junction(selector, element.parentNode)[0])
