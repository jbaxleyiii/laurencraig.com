
###

  Remove a proprety from each element in the current set.

  @param {string} name The name of the property.
  @return junction
  @this junction

###
junction.fn.removeProp = (property) ->

  #= require ./propFix

  name = junction.propFix[property] or property

  @each ->
    this[name] = `undefined`
    delete this[name]

    return
