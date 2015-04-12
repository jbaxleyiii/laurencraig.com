
Crypto = require "crypto"

# handle variables


module.exports = (i, line, block, css) ->


  fileVariables = {}
  fileVariablesRx = /^[\$|@]([a-zA-Z0-9_-]+):([^\;]+)\;/gim
  lineSplitRx = /((\s|-\s)+)/
  variables = {}

  hash = Crypto.createHash('md5').update(css).digest('hex')

  if !fileVariables[hash]
    while (match = fileVariablesRx.exec(css)) != null
      variables[match[1].trim()] = match[2].trim()
    fileVariables[hash] = variables

  # Extract name and any delimiter with description
  tokens = line.split(lineSplitRx, 2)
  name = tokens[0].trim()


  if variables.hasOwnProperty(name)
    return {
      name: name
      description: line.replace(tokens.join(""), "")
      value: variables[name]
      markup:
        example: "$#{name}"
    }
