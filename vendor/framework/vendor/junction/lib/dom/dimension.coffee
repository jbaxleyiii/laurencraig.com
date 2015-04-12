
###

  Private function for setting/getting the offset
  property for height/width.

  NOTE** Please use the [width](width.js.html)
  or [height](height.js.html) methods instead.

  @param {junction} set The set of elements.
  @param {string} name The string "height" or "width".
  @param {float|undefined} value The value to assign.
  @return junction
  @this window

###
junction._dimension = (set, name, value) ->

  if value is `undefined`

    offsetName = name.replace(/^[a-z]/, (letter) ->
      letter.toUpperCase()
    )

    set[0]["offset" + offsetName]

  else

    # support integer values as pixels
    value = (if typeof value is "string" then value else value + "px")
    set.each ->
      this.style[name] = value
      return
