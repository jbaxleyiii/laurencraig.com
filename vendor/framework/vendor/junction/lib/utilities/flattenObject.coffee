

junction.flattenObject = (object) =>
  array = []
  for value of object

    array.push object[value] if object.hasOwnProperty(value)
  return array
