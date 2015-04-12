Template.variables.onCreated ->

  @.subscribe "blocks"


Template.variables.helpers

  variables: ->

    vars = Blocks.find(
      variable:
        $exists: true
    ).fetch()

    for _var in vars

      if _.isArray _var.variable
        if _.isArray _var.variable[0]
          _var.variable = _var.variable[0].slice()
        continue

      _var.variable = [_var.variable]

    return vars

  # colors: ->
  #
  #   vars = Blocks.find(
  #     variable:
  #       $exists: true
  #   ).fetch()
  #
  #   colors = []
  #
  #   for _var in vars
  #     if not _.isArray _var.variable
  #       _var.variable = [_var.variable]
  #
  #     for _rawVar in _var.variable
  #       if _rawVar.value.match /#([a-f]|[A-F]|[0-9]){3}(([a-f]|[A-F]|[0-9]){3})?\b/
  #         console.log _rawVar.value
  #         colors.push _var.variable
  #
  #   return colors



Template.variableDescription.onRendered ->

  $('pre code').each (i, block) ->
    hljs.highlightBlock block
    return
  return
