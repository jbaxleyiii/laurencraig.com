
###

  Filter out the current set if they do *not*
  match the passed selector or the supplied callback returns false

  @param {string,function} selector The selector or boolean return value callback used to filter the elements.
  @return junction
  @this junction

###

junction.fn.filter = (selector) ->

  returns = []

  @each (index) ->

    if typeof selector is "function"

      if selector.call(this, index) isnt false
        returns.push this

    else

      if !this.parentNode

        context = junction(document.createDocumentFragment())

        context[0].appendChild this

        filterSelector = junction(selector, context)
      else

        filterSelector = junction(selector, @parentNode)

      if junction.inArray(this, filterSelector) > -1
        returns.push this
  
    return

  junction returns
