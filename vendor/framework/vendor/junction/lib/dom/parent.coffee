###

  Returns the set of first parents for each element
  in the current set.

  @return junction
  @this junction

###
junction.fn.parent = ->

  returns = []

  @each ->

    # no parent node, assume top level
    # jQuery parent: return the document object for <html> or the parent node if it exists
    parent = ((if this is document.documentElement then document else this.parentNode))

    # if there is a parent and it's not a document fragment
    if parent and parent.nodeType isnt 11
      returns.push parent
    return

  junction returns
