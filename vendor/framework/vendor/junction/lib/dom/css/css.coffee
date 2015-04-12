#= require_tree ./css

###

  Get the compute style property of the first
  element or set the value of a style property
  on all elements in the set.

  @method _setStyle
  @param {string} property The property being used to style the element.
  @param {string|undefined} value The css value for the style property.
  @return {string|junction}
  @this junction
###
junction.fn.css = (property, value) ->

  if !@[0]
    return

  if typeof property is "object"
    @each ->

      for key of property
        if property.hasOwnProperty(key)
          junction._setStyle this, key, property[key]
      return

  else

    # assignment else retrieve first
    if value isnt `undefined`
      return @each ->
        junction._setStyle this, property, value
        return

    junction._getStyle @[0], property
