Path = require "path"
Norma = require "normajs"
Plumber = require "gulp-plumber"


Dss = require "./lib/dss"


module.exports = (config, name) ->

  name or= "dss"

  src = Path.resolve(config.tasks[name].src)
  dest = config.tasks[name].dest

  ###

    This is a sample task
    A callback will be passed in order to run
    through all tasks in a sequenced method

  ###
  Norma.task "#{name}", (cb) ->

    Norma.src([
      src + ".{scss,less,css,stylus,sass}"
      ])
      .pipe Plumber()
      .pipe Dss(config.tasks[name])
      .on("error", Norma.log)


    Norma.log "#{name}: ✔ All done!"
    cb null


  ###

    You can specify the order this task here
    For more information about this see the Norma
    documenation site

  ###
  Norma.tasks["#{name}"].ext = ["scss", "less", "css", "stylus", "sass"]
  Norma.tasks["#{name}"].order = "post"

  # Export all of your tasks
  module.exports.tasks = Norma.tasks
