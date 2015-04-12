###

  Add a class to each DOM element in the set of elements.

  @param {string} className The name of the class to be added.
  @return junction
  @this junction

###

junction.fn.addClass = (className) ->
  classes = className.replace(/^\s+|\s+$/g, "").split(" ")

  @each ->

    for klass in classes

      if this.className isnt undefined
        klass = klass.trim()
        regex = new RegExp("(?:^| )(" + klass + ")(?: |$)")

        withoutClass = !this.className.match regex

        if this.className is "" or withoutClass
          if this.className is ""
            this.className += "#{klass}"
          else
            this.className += " #{klass}"
          return
