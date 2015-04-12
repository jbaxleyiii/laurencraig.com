
do ->
  #= require ./exceptions

  # IE8 uses marginRight instead of margin-right
  convertPropertyName = (str) ->
    str.replace /\-([A-Za-z])/g, (match, character) ->
      character.toUpperCase()

  _getStyle = (element, property) ->
    window.getComputedStyle(element, null).getPropertyValue property

  cssExceptions = junction.cssExceptions

  vendorPrefixes = [
    ""
    "-webkit-"
    "-ms-"
    "-moz-"
    "-o-"
    "-khtml-"
  ]

  ###

    Private function for getting the computed
    style of an element.

    NOTE** Please use the [css](../css.js.html) method instead.

    @method _getStyle
    @param {HTMLElement} element The element we want the style property for.
    @param {string} property The css property we want the style for.

  ###

  junction._getStyle = (element, property) ->

    if cssExceptions[property]

      for exception in cssExceptions[property]

        value = _getStyle element, exception

        return value if value

    for prefix in vendorPrefixes
      convert = convertPropertyName prefix + property

      # VendorprefixKeyName || key-name
      value = _getStyle element, convert

      if convert isnt property
        value = value or _getStyle element, property

      # -vendorprefix-key-name
      if prefix
        value = value or _getStyle element, prefix

      return value if value

    return undefined
