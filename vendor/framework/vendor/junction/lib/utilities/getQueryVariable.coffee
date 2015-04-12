###

  @function getQueryVariable()

  @param {Val}

  @return {Array} array of query values in url string matching the value

  ###
junction.getQueryVariable = (val) ->

  query = window.location.search.substring(1)
  vars = query.split("&")

  results = vars.filter( (element) ->
      pair = element.split "="
      if decodeURIComponent(pair[0]) is val
          return decodeURIComponent(pair[1])
  )

  return results
