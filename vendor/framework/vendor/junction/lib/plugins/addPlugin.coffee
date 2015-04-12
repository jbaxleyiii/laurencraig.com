
junction.addPlugin = (name, obj, attr, cb) ->

  savePlugin = (name, obj, attr, cb) =>

    @['plugins'][name] =
      _id: name
      model: obj
      attr: attr
      callback: cb


  if @.plugins.length

    for plugin in @.plugins
      unless plugin._id isnt obj.name
        savePlugin(name, obj, attr, cb)

      @.addModel document, obj, attr, cb
      return

  else
    savePlugin(name, obj, attr, cb)


  @.addModel document, obj, attr, cb
