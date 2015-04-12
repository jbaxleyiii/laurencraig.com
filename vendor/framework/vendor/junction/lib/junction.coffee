###

  Junction Object Constructor


###

###

  @param {string, object} selector
    The selector to find or element to wrap
  @param {object} context
    The context in which to match the selector
  @returns junction
  @this window

###
junction = (selector, context) ->

  selectorType = typeof selector
  returnElements = []

  if selector


    # if passed a string starting with <, make HTML
    if selectorType is "string" and selector.indexOf("<") is 0

      domFragment = document.createElement "div"

      domFragment.innerHTML = selector

      return junction(domFragment).children().each( ->

        domFragment.removeChild this

      )

    else if selectorType is "function"
      return junction.ready selector

    # if string, use qsa unless id is given
    else if selectorType is "string"

      if context
        return junction(context).find selector

      rquickExpr = /^(?:#([\w-]+)|(\w+)|\.([\w-]+))$/

      # faster selectors
      if match = rquickExpr.exec( selector )

        if (m = match[1])

          elements = [ document.getElementById m ]

        else if ( match[2] )

          elements = document.getElementsByTagName selector


        else if (m = match[3])

          elements = document.getElementsByClassName m

      else
        elements = document.querySelectorAll selector


      returnElements = (element for element in elements)

    else if (Object::toString.call(selector) is "[object Array]" or
      selectorType is "object" and
      selector instanceof window.NodeList
    )

      returnElements = (element for element in selector)

    else
      returnElements = returnElements.concat selector


  returnElements = junction.extend returnElements, junction.fn

  returnElements.selector = selector

  returnElements

junction.fn = {}
junction.state = {}
junction.plugins = {}

junction.extend = (first, second) ->

  for key of second
    if second.hasOwnProperty(key)
      first[key] = second[key]

  first


window["junction"] = junction

  # Map over junction in case of overwrite
_junction = window.junction

# Map over the $ in case of overwrite
_$ = window.$

junction.noConflict = (deep) ->

  if window.$ is junction
    window.$ = _$

  if deep and window.junction is junction
    window.junction = _junction

  junction

#= require_tree ./core
#= require_tree ./utilities
#= require_tree ./data
#= require_tree ./ajax
#= require_tree ./dom
#= require_tree ./events
#= require_tree ./plugins
