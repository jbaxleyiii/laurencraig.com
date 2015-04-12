Template.color.onCreated ->

  @.subscribe "blocks"


Template.color.helpers

  colors: ->

    colors = Blocks.findOne(
      "name": "Colors"
    )


    if colors?.variable?[0]

      for set in colors?.variable?[0]

        map = set.value.split("\n")
        firstLine = map[0].trim()

        if firstLine.indexOf("(") isnt 0
          continue

        for line, index in map
          if line.indexOf("(") > -1
            line = line.replace("(", "{")

          if line.indexOf(")") > -1
            line = line.replace(")", "}")

          if line.indexOf("!default") > -1
            line = line.replace("!default", "")

          if line.indexOf(":") > -1
            pair = line.split(":")
            key = pair[0]

            if pair[1].indexOf("\"") is -1
              value = "\"#{pair[1].trim()}\""
              value = value.replace ",", ""
              value = "#{value},"

            line = "#{key}: #{value}"

          line = line.trim()

          if index is map.length - 2
            line = line.replace ",", ""

          map[index] = line

        try
          renderSafe = []
          safe = JSON.parse map.join("\n")
          for key, value of safe
            safe[key] =
              name: key
              value: value
            renderSafe.push safe[key]

          safe = renderSafe

        catch e
          safe = []

        set.json = safe

    if _.isArray colors.variable

      if _.isArray colors.variable[0]
        colors.variable = colors.variable[0].slice()

        # console.log map
    return colors



Template.color.onRendered ->
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
