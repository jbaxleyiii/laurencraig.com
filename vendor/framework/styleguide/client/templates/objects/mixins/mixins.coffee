Template.mixins.onCreated ->

  @.subscribe "blocks"


Template.mixins.helpers

  mixins: ->

    mixins = Blocks.find(
      "mixin": "true"
    ).fetch()

    for _var in mixins

      if _.isArray _var.parameter
        if _.isArray _var.parameter[0]
          _var.parameter = _var.parameter[0].slice()
        continue

      _var.parameter = [_var.parameter]

    return mixins



Template.mixins.onRendered ->
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
