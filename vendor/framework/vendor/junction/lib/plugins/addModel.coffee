
junction.addModel = (scope, model, attr, cb, force) ->

  for target in scope.querySelectorAll(attr)
    @.nameSpace target, attr, model, force

  if scope.querySelectorAll(attr).length
    if typeof cb is "function"
      cb()
