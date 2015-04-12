###

  Helper function wrapping a call to [ajax](ajax.js.html)
  using the `POST` method.

  @param {string} url The url to POST to.
  @param {object} data The data to send.
  @param {function} callback Callback to invoke on success.
  @return junction
  @this junction

###
junction.post = (url, data, callback) ->
  junction.ajax url,
    data: data
    method: "POST"
    success: callback
