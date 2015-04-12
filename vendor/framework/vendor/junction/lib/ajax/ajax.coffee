


###

  Make an HTTP request to a url.

  NOTE** the following options are supported:

  - *method* - The HTTP method used with the request. Default: `GET`.
  - *data* - Raw object with keys and values to pass with request
      Default `null`.
  - *async* - Whether the opened request is asynchronouse. Default `true`.
  - *success* - Callback for successful request and response
      Passed the response data.
  - *error* - Callback for failed request and response.
  - *cancel* - Callback for cancelled request and response.

  @param {string} url The url to request.
  @param {object} options The options object, see Notes.
  @return junction
  @this junction

###
junction.ajax = (url, options) ->

  # Browser support
  xmlHttp = ->
    try
      return new XMLHttpRequest()
    catch e
      return new ActiveXObject("Microsoft.XMLHTTP")
    return
  

  req = xmlHttp()
  settings = junction.extend({}, junction.ajax.settings)

  if options
    junction.extend settings, options

  if !url
    url = settings.url

  # early exit if no request method or url
  if !req or !url
    return

  req.open settings.method, url, settings.async

  if req.setRequestHeader
    req.setRequestHeader "X-Requested-With", "XMLHttpRequest"

  req.onreadystatechange = ->

    if req.readyState is 4

      # Trim whitespace
      res = (req.responseText or "").replace(/^\s+|\s+$/g, "")

      if req.status.toString().indexOf("0") is 0
        return settings.cancel res, req.status, req

      else if req.status.toString().match(/^(4|5)/) and RegExp.$1
        return settings.error res, req.status, req

      else
        return settings.success res, req.status, req

  if req.readyState is 4
    return req

  req.send settings.data or null
  return req


junction.ajax.settings =
  success: ->
  error: ->
  cancel: ->
  method: "GET"
  async: true
  data: null
