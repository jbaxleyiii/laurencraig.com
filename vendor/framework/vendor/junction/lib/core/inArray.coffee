###

  Check for array membership.

  @param {object} element The thing to find.
  @param {object} collection The thing to find the needle in.
  @return {boolean}
  @this window

###
junction.inArray = (element, collection) ->

  exists = -1

  for item, index in collection

    if collection.hasOwnProperty(index) and
        collection[index] is element
      exists = index

  exists
