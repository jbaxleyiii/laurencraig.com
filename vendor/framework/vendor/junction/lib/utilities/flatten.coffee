
###

  @function flatten()

  @param {Array} single or multilevel array

  @return {Array} a flattened version of an array.

  @note
    Handy for getting a list of children from the nodes.

  ###
junction.flatten = (array) ->

  flattened = []
  for element in array
    if element instanceof Array
      flattened = flattened.concat @.flatten element
    else
      flattened.push element
  flattened
