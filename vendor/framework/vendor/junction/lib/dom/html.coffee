
###

  Gets or sets the `innerHTML` from all the elements in the set.

  @param {string|undefined} html The html to assign
  @return {string|junction}
  @this junction

###

junction.fn.html = (html) ->

  set = (html) ->

    if typeof html is "string"
      @each ->
        this.innerHTML = html
        return

    else

      part = ""

      if typeof html.length isnt "undefined"

        for part in html
          part += part.outerHTML
          return

      else

        part = html.outerHTML

      @each ->
        this.innerHTML = part
        return


  if typeof html isnt "undefined"

    set.call @, html

  # get
  else

    pile = ""

    @each ->
      pile += @innerHTML
      return

    pile
