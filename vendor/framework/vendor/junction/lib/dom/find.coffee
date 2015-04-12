
###

  Find descendant elements of the current collection.

  @param {string} selector The selector used to find the children
  @return junction
  @this junction

###
junction.fn.find = (selector) ->

  returns = []

  @each ->

    try
      rquickExpr = /^(?:#([\w-]+)|(\w+)|\.([\w-]+))$/

      # faster selectors
      if match = rquickExpr.exec( selector )

        if (m = match[1])
          elements = [ document.getElementById m ]

        else if ( match[2] )

          elements = this.getElementsByTagName selector


        else if (m = match[3])

          elements = this.getElementsByClassName m

      else
        elements = this.querySelectorAll selector


    catch e

      return false


    for found in elements
      returns = returns.concat found



  junction returns
