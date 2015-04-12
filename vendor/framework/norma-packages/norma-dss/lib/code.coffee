Dss = require "dss"

module.exports = (name) ->

  _parse = (i, line, block, file) ->

    # taken from dss.markup

    # find the next instance of a parser (if there is one based on the @ symbol)
    # in order to isolate the current multi-line parser

    ###

      Warning! bad/weird code follows!

      In order to handle sass (which uses @ symbols in directives)
      while still breaking between parser tags, I did this
      weird regex lookup and counting method. Sadly my regex skills are
      quite awful so this could be WAY better with someone smarter than
      me

    ###
    # remove all prior comments
    smallBlock = block.split("").splice(i + name.length + 1).join("")
    # split into indiviual lines for cleaning
    smallBlock = smallBlock.split("\n")
    # remove first whitespace character of each line
    for _line, index in smallBlock
      smallBlock[index] = _line.substring(1, _line.length)

    # rebuild into block

    smallBlock = smallBlock.join("\n")

    # set finalChunk to chunk for early returns
    finalChunk = smallBlock



    _filter = (chunk, index) ->

      match = chunk.match /[\t\f ]\@/gm

      if not match
        nextParserIndex = chunk.indexOf('@', index)

        markupLength = if nextParserIndex > -1 then nextParserIndex else chunk.length

        return markupLength


      currentTotal = 1
      for _match, index in match

        oldTotal = chunk.indexOf("@", currentTotal)
        currentTotal = chunk.indexOf("@", oldTotal + 1)

      markupLength = currentTotal - 1
      return markupLength



    _chunkSize = _filter smallBlock, 1
    markup = smallBlock.split("").splice(1, _chunkSize - 1).join("")


    markup = do (markup) ->
      ret = []
      lines = markup.split('\n')
      lines.forEach (line) ->

        pattern = '*'
        index = line.indexOf(pattern)
        if index > 0 and index < 10
          line = line.split('').splice(index + pattern.length, line.length).join('')
        # multiline
        if lines.length <= 2

          line = Dss.trim(line)

        if line and line != "@#{name}"
          ret.push line
        return
      ret.join '\n'

    obj =
      example: markup


    if name is "markup"
      obj.escaped = markup.replace(/</g, '&lt;').replace(/>/g, '&gt;')

    return obj

  return _parse
