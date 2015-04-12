
casper.test.begin "Utility Methods Testing", 8, (test) ->

  casper.start()

    # DEBOUNCE ------------------------------------------------------------------
    # FLATTEN -------------------------------------------------------------------

    # The FLATTEN function takes any array and returns a new array with all the
    # elements flattened into one dimension.

    .then ->

      testArray = @.evaluate ->

        junction("body").append("<div id='flattenTest'></div>")
        junction("#flattenTest").append("<div id='flattenChild1'></div>")
        junction("#flattenTest").append("<div id='flattenChild2'></div>")

        testThing = junction("#flattenTest").children()
        arr = junction.flatten(testThing)
        return arr

      test.assertEquals testArray.length, 2, ["FLATTEN is successful."]

      return


    # FLATTENOBJECT -------------------------------------------------------------

    # The FLATTENOBJECT function works the same as FLATTEN except it accepts
    # and object and turns it into a flattened array.

    .then ->

      testArray = @.evaluate ->

        junction("body").append("<div id='flattenObjectTest'></div>")
        junction("#flattenObjectTest").append("<div id='flattenChild1'></div>")
        junction("#flattenObjectTest").append("<div id='flattenChild2'></div>")

        testObject = []
        testThing = junction("#flattenObjectTest").children()
        testThing.each ->
          element = {}
          element.id = @.id
          testObject.push element

        arr = junction.flattenObject(testObject)
        return arr

      test.assertEquals testArray.length, 2, ["FLATTENOBJECT is successful."]

      return


    # GETKEYS -------------------------------------------------------------------

    # The GETKEYS function returns an array of keys that match a certain value.

    .then ->

      testArray = @.evaluate ->

        junction("body").append("<div id='getKeysTest'></div>")
        junction("#getKeysTest").append("<div id='getKeysChild1'></div>")
        junction("#getKeysTest").append("<div id='getKeysChild2'></div>")

        testObject = []
        testThing = junction("#getKeysTest").children()
        testThing.each ->
          element = {}
          element.id = @.id
          element.zanzabar = "zulu"
          testObject.push element

        arr = junction.getKeys testObject, "zulu"
        # arr = junction.getKeys testObject[0], "zulu" # <--- THIS WORKS
        return arr

      @.echo testArray
      @.echo "This doesn't work if I just pass the testObject object to the"
      @.echo "getKeys function. It DOES work if I pass just one specific item"
      @.echo "testObject doesn't work. testObject[0] does."
      @.echo "I would think I would be able to pass the whole object."
      test.assertEquals testArray[0], "zanzabar", ["GETKEYS is successful."]

      return


    # GETQUERYVARIABLE ----------------------------------------------------------

    # The GETQUERYVARIABLE function returns an array of query variables in the
    # URL string matching the value.

    .thenOpen 'http://localhost:3000?testing=all&thething=all&theotherthing=three', () ->

      testThing = @.evaluate ->

        return junction.getQueryVariable "all"

      @.echo testThing
      @.echo "testThing is returning null. I think the problem is somewhere in"
      @.echo "setting the results in the function. Maybe."

      test.assertEquals testThing[0], "testing", ["GETQUERYVARIABLE is successful."]

      return


    # ISELEMENT -----------------------------------------------------------------

    # The ISELEMENT function determines if the HTMLElement is an actual element.

    .then ->

      thing = @.evaluate ->

        junction("body").append("<div id='isElement'>HELLO</div>")
        testThing = junction("#isElement")
        return junction.isElement(testThing[0])

      test.assertEquals thing, true, ["ISELEMENT is successful."]

      return


    # ISELEMENTINVIEW -----------------------------------------------------------

    # The ISELEMENTINVIEW function determines if the element is in the view.

    .then ->

      # @.echo "testing some things"
      # @.echo @.getCurrentUrl()
      @.capture("../images/test.png")
      testing = @.viewport(1024, 768).then ->
        @.capture("../images/test2.png")

        @.evaluate ->

          testThing = junction("#isElement")
          __utils__.echo testThing
          return junction.isElementInView testThing[0]

      @.echo testing

      test.assertEquals testing, true, ["ISELEMENTINVIEW is successful."]

      return


    # ISMOBILE ------------------------------------------------------------------
    casper.userAgent('Mozilla/5.0 (Macintosh; Intel Mac OS X)')
    casper.userAgent('Mozilla/5.0 (iPhone; CPU iPhone OS 8_1_3 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12B466 Safari/600.1.4')

    casper.thenOpen 'http://google.com/', () ->
      @.echo("I'm a Mac.")
      isThisMobile = @.evaluate ->
        return junction.isMobile()
      @.echo isThisMobile
      @.capture("../images/mac.png")
      test.assertEquals isThisMobile, false, ["ISMOBILE correctly identifies non-mobile user agents."]
      @.userAgent('Mozilla/5.0 (iPhone; CPU iPhone OS 8_1_3 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12B466 Safari/600.1.4')

    casper.thenOpen 'http://google.com/', () ->
      @.echo "I'm an iPhone 5S on iOS 8.1.3"
      isThisMobile = @.evaluate ->
        return junction.isMobile()
      @.echo isThisMobile
      @.capture("../images/iphone.png")
      @.evaluate ->
        __utils__.echo window.navigator.userAgent
      @.echo JSON.stringify @.options.pageSettings.userAgent
      test.assertEquals isThisMobile, true, ["ISMOBILE correctly identifies mobile user agents."]

    # casper.on 'resource.requested', (resource) ->
    #   for obj of resource.headers
    #     name = resource.headers[obj].name
    #     value = resource.headers[obj].value
    #     if name == 'User-Agent'
    #       @echo value
    #   return

    # LAST ----------------------------------------------------------------------
    # TRUTHFUL ------------------------------------------------------------------

  casper.run ->
    test.done()
    return

  return
