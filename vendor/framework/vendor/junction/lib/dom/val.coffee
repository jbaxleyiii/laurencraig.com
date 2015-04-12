
###

  Get the value of the first element or set the value
  of all elements in the current set.

  @param {string} value The value to set.
  @return junction
  @this junction

###
junction.fn.val = (value) ->

  if value isnt `undefined`

    return @.each ->

      if this.tagName is "SELECT"

        options = this.options
        values = []
        i = options.length

        values[0] = value

        while i--

          options = options[i]
          inArray = junction.inArray(option.value, values) >= 0
          if (option.selected = inArray)
            optionSet = true
            newIndex = i

        if !optionSet
          this.selectedIndex = -1
        else
          this.selectedIndex = newIndex

      else
        this.value = value

  else

    el = this[0]

    if el.tagName is "SELECT"

      return "" if el.selectedIndex < 0

    else

      return el.value
