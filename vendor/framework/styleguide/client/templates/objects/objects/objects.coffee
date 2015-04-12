Template.objects.onCreated ->

  @.subscribe "blocks"


Template.objects.helpers

  objects: ->

    objects = Blocks.find(
      "object": "true"
    # ,
      # "sort"
      #   "name": "asc"
    ).fetch()

    blocks = []

    # console.log objects

    # filteredObjects = []
    #

    for _object in objects

      if _object.block.length is 1
        _object.block = _object.block[0]

      if _object.block.name is _object.class
        blocks.push _object
        continue


    for _block in blocks

      for _object in objects
        if _object.name is _block.name
          continue

        if _object.block.name is _block.block.name
          if not _block.children
            _block.children = []

          _block.children.push _object


    return blocks


Template.objects.onRendered ->
  self = @

  self.autorun(_.bind( ->
    # set up cursor in autorun
    blocks = Blocks.find()

    # preform a look up when data is ready to flush tracker
    blocks.forEach((post) -> return)

    # all data should be rendered so highlightBlock
    Tracker.afterFlush(_.bind(->
      @.$("pre code").each (i, block) ->
        hljs.highlightBlock block
        return
    ), @)
  ), self)
