###

  Load the HTML response from `url` into the current set of elements.

  @param {string} url The url to GET from.
  @param {function} callback Callback to invoke after HTML is inserted.
  @return junction
  @this junction

###
junction.fn.load = (url, callback) ->
  self = @
  args = arguments

  intCB = (data) ->

    self.each ->
      junction(this).html data
      return

    if callback
      callback.apply self, args
    return

  junction.ajax url,
    success: intCB

  return @
