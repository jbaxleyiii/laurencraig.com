
###

  Get data attached to the first element or set data values on
  all elements in the current set

  @param {string} name The data attribute name
  @param {any} value The value assigned to the data attribute
  @return {any|junction}
  @this junction

###

junction.fn.data = (name, value) ->
  if name isnt undefined

    if value isnt undefined
      @each ->
        @junctionData = {}  unless @junctionData
        @junctionData[name] = value
        return

    else
      if @[0] and @[0].junctionData
        @[0].junctionData[name]
      else
        undefined


  else
    (if @[0] then @[0].junctionData or {} else undefined)
