
###

  Get the value of the first element of the set or set
  the value of all the elements in the set.

  @param {string} name The attribute name.
  @param {string} value The new value for the attribute.
  @return {junction|string|undefined}
  @this {junction}

###
junction.fn.attr = (name, value) ->

  nameStr = typeof (name) is "string"

  if value isnt undefined or not nameStr

    @each ->
      if nameStr
        this.setAttribute name, value
      else
        for i of name
          if name.hasOwnProperty(i)
            this.setAttribute i, name[i]

      return

  else
    (if this[0] then this[0].getAttribute(name) else undefined)
