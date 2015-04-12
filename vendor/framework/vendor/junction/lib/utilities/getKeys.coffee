###

@function getKeys()

@param {Object}
@param {value}

@return {Array} array of keys that match on a certain value

@note
  helpful for searching objects


@todo add ability to search string and multi level

###
junction.getKeys = (obj, val) ->
  objects = []
  for element of obj
    continue unless obj.hasOwnProperty(element)
    if obj[element] is "object"
      objects = objects.concat @.getKeys obj[element], val
    else
      objects.push element if obj[element] is val
  objects
