
###

  Returns a boolean if elements have the class passed

  @param {string} selector The selector to check.
  @return {boolean}
  @this {junction}

###

junction.fn.hasClass = (className) ->


  returns = false

  @each ->
    regex = new RegExp(" " + className + " ")
    returns = (regex.test " " + this.className + " ")


  returns
