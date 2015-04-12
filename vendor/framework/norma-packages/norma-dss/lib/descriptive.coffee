Dss = require "dss"

module.exports = (i, line, block, file) ->

  parameter = line.split(' - ')
  return {
    name: if (parameter[0]) then Dss.trim(parameter[0]) else ''
    description: if (parameter[1]) then Dss.trim(parameter[1]) else ''
  }
