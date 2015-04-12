###

@function isElementInView()

@param {Element} element to check against

@return {Boolean} if element is in view

###
junction.isElementInView = (element) ->
  if element instanceof jQuery then element = element.get(0)
  coords = element.getBoundingClientRect()

  (
    Math.abs(coords.left) >= 0 and
    Math.abs(coords.top)
  ) <= (
    window.innerHeight or
    document.documentElement.clientHeight
  )
