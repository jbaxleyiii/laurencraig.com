
###

  Remove a class from each DOM element in the set of elements.

  @param {string} className The name of the class to be removed.
  @return junction
  @this junction

###
junction.fn.removeClass = (className) ->

  classes = className.replace(/^\s+|\s+$/g, "").split(" ")

  @each ->

    for klass in classes

      if this.className isnt `undefined`

        regex = new RegExp("(^|\\s)" + klass + "($|\\s)", "gmi")

        newClassName = this.className.replace(regex, " ")

        this.className = newClassName.replace(/^\s+|\s+$/g, "")

      return
