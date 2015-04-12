
###

  Toggles class of elements in selector

  @param {string} className Class to be toggled
  @return junction
  @this junction

###

junction.fn.toggleClass = (className) ->

  if @hasClass className
    @removeClass className
  else
    @addClass className
