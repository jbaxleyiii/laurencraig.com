
HTTP = require "http"
Fs = require "fs"
Path = require "path"
Querystring = require "querystring"
Url = require "url"

Through = require "through"
_ = require "underscore"
Dss = require "dss"
Norma = require "normajs"

Vars = require "./vars"
Simple = require "./simple"
Descriptive = require "./descriptive"
Code = require "./code"


_simple = [
  # name
  "class"
  "link"
  # description

  "function"
  "mixin"
  "extend"

  "base"
  "helper"
  "object"
  "complex-object"
  "trump"

  "private"

  "namespaced"

  "note"
]


_descriptive = [

  "extends"
  "mixins"

  "parameter"
  "default"

  "bug"

  "block"
  "element"
  "modifier"

]

_code = [

  "scss"
  "less"
  "stylus"
  "sass"
  "css"

  "markup"

  "javascript"
  "coffeescript"

]



module.exports = (config) ->


  Dss.parser "variable", Vars

  if config.simple
    _simple = _.union _simple, config.simple

  Dss.parser(item, Simple) for item in _simple

  if config.descriptive
    _descriptive = _.union _descriptive, config.descriptive
  Dss.parser item, Descriptive for item in _descriptive

  if config.code
    _code = _.union _code, config.code
  Dss.parser item, Code(item) for item in _code


  dest = if config.dest then config.dest else "localhost:3000/api/v1/blocks"

  firstFile = null
  contents = null

  read = (file) ->

    if file.isNull()
      return

    if file.isStream()

      Norma.emit "error", new Error("Streams are not supported.")

      return

    parseOptions = {}

    if config.parseOptions
      parseOptions = _.extend parseOptions, config.parseOptions

    Dss.parse file.contents.toString(), parseOptions, (dssFile) ->

      isBlank = (dssFile) ->
        dssFile.blocks.length is 0

      isValid = (block) ->
        return block.name isnt undefined

      firstFile or= file
      contents or= []

      # filter
      dssFile.blocks = (blocks for blocks in dssFile.blocks if isValid)

      objToArray = _descriptive.slice()
      objToArray.push "variable"
      objToArray.push "state"

      for _block, index in dssFile.blocks by -1

        _block.file = dssFile.file

        for item of _block
          if not _block[item]
            delete _block[item]

        # delete empty item
        if not Object.keys(_block).length
          dssFile.blocks.splice(index, 1)
          continue


        for _obj in objToArray
          if not _block[_obj]
            continue

          if _.isObject(_block[_obj])
            _block[_obj] = [_block[_obj]]




      if isBlank(dssFile)
        return

      dssFile["file"] = Path.basename file.path
      contents.push dssFile


    return


  end = ->

    Norma.log "updating application..."


    if Fs.existsSync( Path.join(process.cwd(), dest))
      _pipe = require(Path.join(process.cwd(), dest))(contents)
      @.emit "end"
      return

    loc = Url.parse dest

    if not loc.hostname
      Norma.log "please include a valid url or a file to send data"
      @.emit "end"
      return

    options =
      hostname: loc.hostname
      path: loc.path
      method: "POST"
      headers:
        "Content-Type": "application/json"

    if loc.port
      options.port = Number loc.port


    req = HTTP.request options, (res) ->
      res.setEncoding 'utf8'
      res.on 'data', (chunk) ->
        Norma.log "updated app with: #{chunk}"
        return

      res.on "error", (error) ->
        Norma.emit "error", error
        return

      return

    req.on "error", (error) ->
      Norma.emit "error", error
      return

    req.write JSON.stringify contents

    req.end()


    @.emit "end"




  return Through read, end
