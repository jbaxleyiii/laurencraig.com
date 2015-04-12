###

  Helper function wrapping a call to [ajax](ajax.js.html)
  using the `GET` method.

  @param {string} url The url to GET from.
  @param {function} callback Callback to invoke on success.
  @return junction
  @this junction

###
junction.get = (url, callback) ->
  junction.ajax url,
    success: callback
