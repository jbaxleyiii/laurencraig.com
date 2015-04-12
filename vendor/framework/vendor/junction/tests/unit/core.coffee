
casper.test.begin "Core Methods", 2, (test) ->


  casper.start()

    # Junction is ready
    .then ->

      test.assertEvalEquals (->

        ready = false
        junction(document).ready( ->
          ready = true
        )

        return ready
      ), true, "Junction is ready"

      return


    .then ->

      @.evaluate ->
        div = document.createElement "div"
        div.id = "test"

        document.body.appendChild div


      test.assertEvalEquals (->

        test = junction "#test"

        for item in test
          if item is document.getElementById("test")
            return true

        return false

      ), true, "Junction returns array of nodes"



  casper.run ->
    test.done()
    return

  return
