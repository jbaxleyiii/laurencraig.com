###

@function truthful()

@param {Array} any array to be tested for true values

@return {Array} array without false values

@note
  Handy for triming out all falsy values from an array.

###

junction.truthful = (array) ->
  item for item in array when item
