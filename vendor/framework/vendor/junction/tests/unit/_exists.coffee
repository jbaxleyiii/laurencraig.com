

casper.test.begin "Junction is present", 2, (test) ->


  casper.start()

    # Library is present
    .then ->

      @.page.injectJs("./out/junction.js")

      test.assertEvalEquals (->
        return typeof junction
      ), "function", "Junction is present"


    # Library has methods
    .then ->

      test.assertEvalEquals (->
        return Object.keys(junction).length > 0
      ), true, "Junction has methods"

      return




  casper.run ->
    test.done()
    return

  return
