
###

  Remove data associated with `name` or all the data, for each
  element in the current set

  @param {string} name The data attribute name
  @return junction
  @this junction

###

junction.fn.removeData = (name) ->
  @each ->
    if name isnt undefined and @junctionData
      @junctionData[name] = undefined
      delete @junctionData[name]
      return
    else
      @[0].junctionData = {}
      return
