
junction.updateModels = (scope, force) ->

  for plugin in @flattenObject @['plugins']
    @.addModel scope, plugin.model, plugin.attr, false, force
