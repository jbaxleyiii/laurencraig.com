
junction.nameSpace = (target, attribute, obj, force) ->

  originalAttr = attribute.replace(/[\[\]']+/g,'')

  # get id for namespace
  params = target.attributes[originalAttr].value.split(',')

  # clean up whitespace
  params = params.map (param) -> param.trim()

  # set attribute name
  attribute = originalAttr.split '-'

  # add to core object
  if !@[attribute[1]]
    @[attribute[1]] = {}


  # Create new object and bind it to its nameSpace
  if !@[attribute[1]][params[0]] or force
    @[attribute[1]][params[0]] = null
    @[attribute[1]][params[0]] = new obj target, originalAttr
