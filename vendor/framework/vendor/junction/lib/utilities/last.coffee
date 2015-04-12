
###

@function last()

@param {Array}
@param {Val} ** optional

@return {Val} last value of array or value certain length from end

###
junction.last = (array, back) ->
  array[array.length - (back or 0) - 1]
