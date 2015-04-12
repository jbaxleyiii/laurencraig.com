
###

  Gets the property value from the first element
  or sets the property value on all elements of the currrent set.

  @param {string} name The property name.
  @param {any} value The property value.
  @return {any|junction}
  @this junction

###
junction.fn.prop = (name, value) ->

  #= require ./propFix

  if !@[0]
    return

  name = junction.propFix[name] or name

  if value isnt `undefined`
    @each ->
      this[name] = value
      return

  else
    return @[0][name]
