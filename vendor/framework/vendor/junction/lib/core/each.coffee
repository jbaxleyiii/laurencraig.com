###

  Iterates over `junction` collections.

  @param {function} callback The callback to be invoked on
    each element and index
  @return junction
  @this junction

###
junction.fn.each = (callback) ->

  junction.each this, callback


junction.each = (collection, callback) ->

  for item in collection
    val = callback.call item, _i, item

    if val is false
      break

  collection
