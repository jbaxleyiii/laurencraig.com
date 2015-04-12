
do ->
  #= require ./exceptions


  # IE8 uses marginRight instead of margin-right
  convertPropertyName = (str) ->
    str.replace /\-([A-Za-z])/g, (match, character) ->
      character.toUpperCase()

  cssExceptions = junction.cssExceptions

  ###

    Private function for setting the style of an element.

    NOTE** Please use the [css](../css.js.html) method instead.

    @method _setStyle
    @param {HTMLElement} element The element we want to style.
    @param {string} property The property being used to style the element.
    @param {string} value The css value for the style property.

  ###

  junction._setStyle = (element, property, value) ->

    convertedProperty = convertPropertyName property

    element.style[property] = value

    if convertedProperty isnt property
      element.style[convertedProperty] = value

    if cssExceptions[property]
      for exception in cssExceptions[property]
        element.style[exception] = value
        return
