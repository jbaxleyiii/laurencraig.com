
casper.test.begin "DOM Testing", 53, (test) ->


  casper.start()

    # ADD ---------------------------------------------------------------------

    # The ADD function adds the item to the current set of items that can have
    # other actions taken on them. For example, after performing an ADD you
    # may want to add a css class to all the tiems in the set.

    .then ->

      originalCount = 0
      testCount = 0
      combinedThingCount = 0

      @.evaluate ->

        originalCount = junction("body").length
        testCount = junction("#test").length
        combinedThing = junction("body").add("#test")
        combinedThingCount = thing.length

      test.assertEquals originalCount + testCount,
                        combinedThingCount,
                        ["ADD is successful"]

      return


    # ADD-CLASS ---------------------------------------------------------------

    # The ADD-CLASS function adds a css class to the item selected.

    .then ->

      @.evaluate ->

        junction("#test").addClass("testing")

      test.assertExists ".testing", ["ADDCLASS is successful"]

      return


    # AFTER -------------------------------------------------------------------

    # The AFTER function adds the designated markup AFTER the selected item.

    .then ->

      @.evaluate ->

        junction("#test").append("<div id='foo-before'></div>")
        junction("#foo-before").after("<div id='foo-after'></div>")

      testElement = @.evaluate ->
        te = document.getElementById("foo-before")
        temp = te.nextSibling
        return temp

      test.assertEquals testElement.attributes[0].textContent,
                        "foo-after",
                        ["AFTER is successful"]

      return


    # APPEND ------------------------------------------------------------------

    # The APPEND function adds the element as the last child of the selected item

    .then ->

      # resultWrapper = @evaluate(->
      #   wrapper = {}
      #   try
      #     junction("<div id=\"second\"></div>").appendTo("#test")
      #
      #     # store your return values in the wrapper
      #   catch error
      #     wrapper.error = error
      #   wrapper
      # )
      #
      # # Handle the result and possible errors:
      # if resultWrapper.error
      #   error = resultWrapper.error
      #   @echo "An error occurred: " + JSON.stringify(error.message)

      # else
      #   result = JSON.stringify(resultWrapper.result)
      #   @echo result

      @.evaluate ->

        junction("body").append "<div id=\"second\"></div>"

      test.assertExists "#second", ["APPEND is successful"]

      return


    # APPENDTO ----------------------------------------------------------------

    # The APPENDTO function works the same as the APPEND function...just
    # is written backwards.

    .then ->

      @.evaluate ->

        junction("<div id='appendTo'></div>").appendTo("body")

      test.assertExists "#appendTo", ["APPENDTO is successful"]

      return


    # ATTR --------------------------------------------------------------------

    # The ATTR function gets the value of the first element of the set or
    # sets the value of all the elements in the set.

    .then ->

      # should return null if the item doesn't exist
      theThing = @.evaluate ->

        junction("#this_does_not_exist").attr("class")

      test.assertEquals theThing, null, ["ATTR returns null if the item doesn't exist"]

      # should get the attribute
      theThing = @.evaluate ->

        junction("#test").attr("class")

      test.assertEquals theThing, "testing", ["ATTR successfully get the attribute"]

      # should set the attribute
      theThing = @.evaluate ->

        junction("#test").attr("class", "foo").attr("class")

      test.assertEquals theThing, "foo", ["ATTR successfully sets an attribute"]

      return


    # BEFORE ------------------------------------------------------------------

    # The BEFORE function adds the designated markup BEFORE the selected item.

    .then ->

      @.evaluate ->

        junction("body").append("<div id='before'></div>")
        junction("#before").append("<div id='foo-after2'></div>")
        junction("#foo-after2").before("<div id='foo-before2'></div>")

      testElement = @.evaluate ->
        te = document.getElementById("foo-after2")
        temp = te.previousSibling
        return temp

      test.assertEquals testElement.attributes[0].textContent,
                        "foo-before2",
                        ["BEFORE is successful"]

      return


    # CHILDREN ----------------------------------------------------------------

    # The CHILDREN function gets the children of the current element

    .then ->

      numOfChildren = @.evaluate ->

        test = junction("#before")
        test.html("<div id='el'></div>")
        element = junction("#el")
        return test.children().length

      test.assertEquals numOfChildren, 1, ["CHILDREN is successful"]

      return


    # CLONE -------------------------------------------------------------------

    # The CLONE function creates a new junction object containing the currently
    # selected elements

    .then ->

      @.evaluate ->

        junction("body").append("<div id='clone'></div>")
        junction("#clone").addClass("clone")

      clonedClass = @.evaluate ->

        element = junction("#clone").clone()
        element.attr("class", "foo").attr("class")
        return element.attr("class")

      originalClass = @.evaluate ->

        element = junction("#clone")
        return element.attr("class")

      test.assertEquals clonedClass, "foo", ["CLONE is successful"]
      test.assertEquals originalClass, "clone", ["CLONE doesn't modify original set"]

      return


    # CLOSEST -----------------------------------------------------------------

    # The CLOSEST function looks in the current set of elements and it's
    # parents for the first element that matches.

    .then ->

      @.evaluate ->

        junction("body").append("<div id='closest'></div>")
        junction("#closest").append("<div id='closestChildOne'></div>")
        junction("#closest").append("<div id='closestChildTwo'></div>")

      closestDiv = @.evaluate ->

        return junction("#closestChildOne").closest("#closest")

      test.assertEquals closestDiv[0].id, "closest", ["CLOSEST is successful"]

      return


    # CSS ---------------------------------------------------------------------

    # The CSS function gets and/or sets the style from the selected element

    .then ->

      @.evaluate ->

        junction("body").append("<div id='css'></div>")
        junction("#css").css("margin-top", "2px")

      testThing = @.evaluate ->

        test = junction("#css")
        return junction._getStyle(test[0], "margin-top")

      test.assertEquals testThing, "2px", ["CSS is successful"]

      return


    # EQ ----------------------------------------------------------------------

    # The EQ function returns the item at the specified index in a junction object

    .then ->

      @.evaluate ->

        junction("body").append("<div id='eq'></div>")

      testThing = @.evaluate ->

        return junction("#eq")

      testThing2 = @.evaluate ->

        return junction("#eq").eq(0)

      testThing3 = @.evaluate ->

        return junction("#eq").eq(100000)

      test.assertEquals testThing2[0], testThing[0], ["EQ is successful"]

      test.assertEquals testThing3[0], undefined, ["EQ out of range is undefined"]

      return


    # FILTER ------------------------------------------------------------------

    # The FILTER function filters out the selected set if it does NOT match
    # the specified element.

    .then ->

      @.evaluate ->

        junction("body").append("<div id='filter'></div>")
        junction("#filter").append("<div id='filterChild'></div>")

      numberOfDivs = @.evaluate ->

        test = junction("div")
        return test.filter("#filterChild").length

      test.assertEquals numberOfDivs, 1, ["FILTER is successful"]

      return


    # FIND --------------------------------------------------------------------

    # The FIND function finds the selected item.

    .then ->

      testThing = @.evaluate ->

        return junction("body").find("#test").attr("class")

      test.assertEquals testThing, "foo", ["FIND is successful"]

      return


    # FIRST -------------------------------------------------------------------

    # The FIRST function returns the first element of the set.

    .then ->

      @.evaluate ->

        junction("body").append("<div id='firstOne' class='first'></div>")
        junction("body").append("<div id='firstTwo' class='first'></div>")

      testThing = @.evaluate ->

        return junction(".first").first()[0]

      test.assertEquals testThing.id, "firstOne", ["FIRST is successful"]

      return


    # GET ---------------------------------------------------------------------

    # The GET function returns the DOM node at the passed index.

    .then ->

      testThing = @.evaluate ->

        return junction("#test")

      getThing = @.evaluate ->

        return junction("#test").get(0)

      test.assertEquals getThing.id, testThing[0].id, ["GET is successful"]

      return


    # HASCLASS ----------------------------------------------------------------

    # The HASCLASS function tells you if a particular element has the specified
    # class.

    .then ->

      hasFooClass = @.evaluate ->

        return junction("#test").hasClass("foo")

      test.assertEquals hasFooClass, true, ["HASCLASS is successful"]

      return


    # HEIGHT ------------------------------------------------------------------

    # The HEIGHT function gets the height of the first element, or sets the
    # height for everything in the set.

    .then ->

      setHeight = @.evaluate ->

        junction("body").append("<div id='height'></div>")
        junction("#height").height(300)
        return junction("#height").height()

      test.assertEquals setHeight, 300, ["HEIGHT is successful"]

      return


    # HTML --------------------------------------------------------------------

    # The HTML function gets/sets the innerHTML attribute for all the elements.

    .then ->


      @.evaluate ->

        junction("body").append("<div id='html'></div>")
        junction("#html").append("<div id='htmlChildOne'></div>")
        junction("#html").append("<div id='htmlChildTwo'></div>")

      htmlOne = @.evaluate ->

        htmlOne = junction("#htmlChildOne")
        htmlOne.innerHTML = "<div id=\"htmlTest\"></div>"
        return htmlOne.innerHTML

      htmlTwo = @.evaluate ->

        htmlTwo = junction("#htmlChildTwo").html("<div id=\"htmlTest\"></div>")
        return htmlTwo.html()

      test.assertEquals htmlTwo, htmlOne, ["HTML is successful"]

      return


    # INDEX -------------------------------------------------------------------

    # The INDEX function returns the index of the current element in the set.
    # If you don't specify the selector it will return the first node.

    # NOTE: Couldn't figure out how to get this to work. Seems like this
    # should work. The INDEX is returning null.

    # From SHOESTRING:

		# <div class="index">
		# 	<div class="first"></div>
		# 	<div class="second"></div>
		# </div>

  	# test('`.index()`', function() {
  	# 	var $indexed = $fixture.find( ".index div" );
  	# 	equal( $indexed.index( ".first" ), 0 ); <--- I'm testing this
  	# 	equal( $indexed.index( ".second" ), 1 );
    #
  	# 	var $second = $fixture.find( ".index .second" );
  	# 	equal( $second.index(), 1 );
  	# });

    .then ->

      testThing = @.evaluate ->

        junction("body").append("<div class='index'></div>")
        junction(".index").append("<div class='childOne'></div>")
        junction(".index").append("<div class='childTwo'></div>")

        thing = junction(".index div")
        return thing.index(".childOne")

      @.echo testThing

      # test.assertEquals 1, 1, ["Index isn't finished yet."]
      test.assertEquals testThing, 0, ["INDEX is successful."]

      return


    # INSERTAFTER -------------------------------------------------------------

    # The INSERTAFTER function inserts the current set of things AFTER the
    # matching selector.

    .then ->

      @.evaluate ->

        junction("body").append("<div id='insertAfter'></div>")
        junction("<div id='insertAfter2'></div>").insertAfter("#insertAfter")

      testElement = @.evaluate ->

        te = document.getElementById("insertAfter")
        temp = te.nextSibling
        return temp

      test.assertEquals testElement.attributes[0].textContent,
                        "insertAfter2",
                        ["INSERTAFTER is successful."]

      return


    # INSERTBEFORE ------------------------------------------------------------

    # The INSERTBEFORE function inserts the current set of things BEFORE the
    # matching selector.

    .then ->

      @.evaluate ->

        junction("body").append("<div id='insertBefore'></div>")
        junction("<div id='insertBefore2'></div>").insertBefore("#insertBefore")

      testElement = @.evaluate ->

        te = document.getElementById("insertBefore")
        temp = te.previousSibling
        return temp

      test.assertEquals testElement.attributes[0].textContent,
                        "insertBefore2",
                        ["INSERTBEFORE is successful."]

      return


    # IS ----------------------------------------------------------------------

    # The IS function checks to see if anything in the current set of elements
    # matches the selector.

    .then ->

      testThing = @.evaluate ->

        return junction("#test").is("#test")

      test.assertEquals testThing, true, ["IS is success."]

      return


    # LAST --------------------------------------------------------------------

    # The LAST function returns the last element of a set.

    .then ->

      @.evaluate ->

        junction("body").append("<div id='lastOne' class='last'></div>")
        junction("body").append("<div id='lastTwo' class='last'></div>")

      testThing = @.evaluate ->

        return junction(".last").last()[0]

      test.assertEquals testThing.id, "lastTwo", ["LAST is successful"]

      return


    # NEXT --------------------------------------------------------------------

    # The NEXT function returns an object with the set of siblings of each
    # element in the original set.

    # NOTE: Maybe I don't know what I'm doing but I don't think this is
    # working correctly. There are 3 things inside .next so thing.next().length
    # should be returning 2. Instead it's returning 0.

    # From SHOESTRING:

    # <div class="next">
		# 	<div class="first"></div>
		# 	<div class="second"></div>
		# 	<div class="third"></div>
		# </div>
    #
  	# test( '`.next()`', function() {
  	# 	var $first, $all;
    #
  	# 	$first = $fixture.find( ".next .first" );
  	# 	$all = $fixture.find( ".next > div" );
    #
    #
  	# 	equal( $first.next().length, 1 );
  	# 	equal( $first.next()[0], $fixture.find(".next .second")[0]);
    #
  	# 	equal( $all.next().length, 2 ); <--- I'M TESTING THIS
  	# 	equal( $all.next()[0], $fixture.find(".next .second")[0]);
  	# 	equal( $all.next()[1], $fixture.find(".next .third")[0]);
  	# 	equal( $all.next()[2], undefined );
  	# });

    .then ->

      nextLength = @.evaluate ->

        junction("body").append("<div class='next'></div>")
        junction(".next").append("<div class='one'></div>")
        junction(".next").append("<div class='two'></div>")
        junction(".next").append("<div class='three'></div>")

        thing = junction("body").find(".next > div")
        return thing.next().length

      @.echo nextLength

      test.assertEquals nextLength, 2, ["NEXT is successful."]

      return


    # NOT ---------------------------------------------------------------------

    # The NOT function removes the selected elements from the current set

    .then ->

      isSoCount = @.evaluate ->

        junction("body").append("<div class='not'></div>")
        junction(".not").append("<div class='is-not'></div>")
        junction(".not").append("<div class='is-so'></div>")
        junction(".not").append("<div class='is-not'></div>")

        thing = junction(".not > div")
        return thing.not(".is-not").length

      test.assertEquals isSoCount, 1, ["NOT is successful."]

      return


    # OFFSET ------------------------------------------------------------------

    # The OFFSET function returns an object with the "top" and "left" properties
    # of the first elements offsets

    # SHOESTRING does NOT have a test for this.

    .then ->

      test.assertEquals 1, 1, ["OFFSET is not finished."]

      return


    # PARENT ------------------------------------------------------------------

    # The PARENT function returns the first parents for each element in the set.

    # TODO: Add a second test for the second child

    .then ->

      parent = @.evaluate ->

        junction("body").append("<div class='parent'></div>")
        junction(".parent").append("<div class='child'></div>")
        junction(".parent").append("<div class='child'></div>")

        return junction(".parent")[0]

      childOneParent = @.evaluate ->

        children = junction(".child")

        return children.parent()[0]

      test.assertEquals childOneParent.attributes[0].textContent,
                        parent.attributes[0].textContent,
                        ["PARENT is successful."]

      return


    # PARENTS -----------------------------------------------------------------

    # The PARENTS functions returns the set of all parents matching the selector
    # for each element in the set.

    # TODO: create tests for the rest of the parents array. See "echo" for the
    # rest of the items.

    .then ->

      @.evaluate ->

        junction("body").append("<div class='parents'></div>")
        junction(".parents").append("<div class='parentOne'></div>")
        junction(".parentOne").append("<div class='child'></div>")
        junction(".parents").append("<div class='parentTwo'></div>")
        junction(".parentTwo").append("<div class='child'></div>")

        parents = junction(".parents")

        children = parents.find(".child")

        # __utils__.echo children.parents().length
        # __utils__.echo children.parents()[0].attributes[0].textContent
        # __utils__.echo children.parents()[1].attributes[0].textContent
        # __utils__.echo children.parents()[2]
        # __utils__.echo children.parents()[3].innerHTML
        # __utils__.echo junction("html")[0].innerHTML
        # __utils__.echo children.parents()[4].attributes[0].textContent

      index0 = @.evaluate ->

        indexThing = junction(".parents").find(".child").parents()[0]
        return indexThing.attributes[0].textContent

      index1 = @.evaluate ->

        indexThing = junction(".parents").find(".child").parents()[1]
        return indexThing.attributes[0].textContent

      test.assertEquals index0, "parentOne", ["PARENTS returns correct parent at index 0."]
      test.assertEquals index1, "parents", ["PARENTS returns correct parent at index 1"]

      return


    # PREPEND -----------------------------------------------------------------

    # The PREPEND function adds the element or HTML string before the children
    # of each element in the set.

    # NOTE: It looks like this function doesn't work right now.

    # From SHOESTRING:

		# <div class="prepend">
		# </div>
    #
    # test( '`.prepend() adds a first child element', function() {
  	# 	var tmp, $prepend = $fixture.find( ".prepend" );
    #
  	# 	tmp = $(	"<div class='first'></div>" );
  	# 	$prepend.append( tmp[0] );
  	# 	$prepend.append( "<div class='second'></div>" );
  	# 	$prepend.append( ".testel" );
    #
  	# 	equal( $prepend.find( ".first" )[0], tmp[0] );
  	# 	equal( $prepend.find( ".second" ).length, 1 );
  	# 	equal( $prepend.find( ".testel" ).length, 1 );
  	# });

    # Interestingly, they don't actually test with .prepend here. This may
    # may not work on their end either.

    # As a first step I'm just trying to test whether or not the item was
    # actually added to the DOM. That is failing.

    .then ->

      @.evaluate ->

        junction("body").append("<div class='prepend'></div>")

        junction(".prepend").prepend("<div class='.firstPrependedThing'></div>")

      # test.assertEquals 1, 1, ["Prepend is not finished."]
      test.assertExists ".firstPrependedThing", ["PREPEND is successful"]

      return


    # PREPENDTO ---------------------------------------------------------------

    # The PREPENDTO function adds each element of the current set BEFORE the
    # children of the selected elements.

    # NOTE: I just going to guess that this function doesn't work yet. The
    # Shoestring docs show the test for it using AppendTo. That tells me it
    # doesn't work yet. Will try to clarify and then revisit.

    # From SHOESTRING:

  	# test( '`.prependTo() adds the all elements to the selected element` ', function() {
  	# 	var tmp, $prepend = $fixture.find( ".prepend" );
    #
  	# 	tmp = $(	"<div class='first'></div>" );
    #
  	# 	tmp.appendTo( "#qunit-fixture > .prepend" );
    #
  	# 	equal( $prepend.find( ".first" )[0], tmp[0] );
  	# });

    .then ->

      @.evaluate ->

        junction("<div class='prependTo'></div>").prependTo("body")

      test.assertExists ".prependTo", ["PREPENDTO is successful."]

      return


    # PREV --------------------------------------------------------------------

    # The PREV function returns an object containing one sibling before each
    # element in the original set.

    # It doesn't seem like this is working either. According to the Shoestring
    # tests thing.prev().length here should return 1.

    # From SHOESTRING:

		# <div class="prev">
		# 	<div class="first"></div>
		# 	<div class="second"></div>
		# 	<div class="third"></div>
		# </div>

  	# test( '`.prev()`', function() {
  	# 	var $last, $all;
    #
  	# 	$last = $fixture.find( ".prev div.third" );
  	# 	$all = $fixture.find( ".prev > div" );
    #
  	# 	equal( $last.prev().length, 1 ); <--- I'M TESTING THIS
  	# 	equal( $last.prev()[0], $fixture.find(".prev .second")[0]);
    #
  	# 	// ordering correct according to jquery api
  	# 	// http://api.jquery.com/prev/
  	# 	equal( $all.prev().length, 2 );
  	# 	equal( $all.prev()[0], $fixture.find(".prev .first")[0]);
  	# 	equal( $all.prev()[1], $fixture.find(".prev .second")[0]);
  	# 	equal( $all.prev()[2], undefined );
  	# });

    .then ->

      prevLength = @.evaluate ->

        junction("body").append("<div class='prev'></div>")
        junction(".prev").append("<div class='prevOne'></div>")
        junction(".prev").append("<div class='prevTwo'></div>")
        junction(".prev").append("<div class='prevThree'></div>")

        thing = junction(".prev div.prevThree")

        return thing.prev().length

      @.echo prevLength

      test.assertEquals prevLength, 1, ["PREV is successful."]

      return


    # PREVALL -----------------------------------------------------------------

    # The PREVALL function returns an object with the set of ALL siblings before
    # each element in the original set.

    # This doesn't look like it's working. According to the Shoestring tests
    # thing.prevAll().length should be returning 2.

    # From SHOESTRING:

		# <div class="prevall">
		# 	<div class="first"></div>
		# 	<div class="second"></div>
		# 	<div class="third"></div>
		# </div>

  	# test( '`.prevAll()`', function() {
  	# 	var $last;
    #
  	# 	$last = $fixture.find( ".prevall div.third" );
    #
  	# 	equal( $last.prevAll().length, 2 ); <--- I"M TESTING THIS
    #
  	# 	// ordering correct according to jquery api
  	# 	// http://api.jquery.com/prevall/
  	# 	equal( $last.prevAll()[0], $fixture.find(".prevall .second")[0]);
  	# 	equal( $last.prevAll()[1], $fixture.find(".prevall .first")[0]);
  	# 	equal( $last.prevAll()[2], undefined );
  	# });

    .then ->

      prevAllLength = @.evaluate ->

        junction("body").append("<div class='prevall'></div>")
        junction(".prevall").append("<div class='prevallOne'></div>")
        junction(".prevall").append("<div class='prevallTwo'></div>")
        junction(".prevall").append("<div class='prevallThree'></div>")

        thing = junction(".prevall div.prevallThree")

        return thing.prevAll().length

      @.echo prevAllLength

      test.assertEquals prevAllLength, 2, ["PREVALL is successful."]

      return


    # PROP --------------------------------------------------------------------

    # The PROP function gets the property value on the first element or sets
    # the property value on all the elements in the set.

    .then ->

      # gets the property
      property = @.evaluate ->

        junction("body").append("<div class='prop'></div>")

        return junction(".prop").prop("class")

      test.assertEquals property, "prop", ["PROP gets the property correctly"]

      property = @.evaluate ->

        junction(".prop").prop("class", "bar")

        return junction(".bar").prop("class")

      test.assertEquals property, "bar", ["PROP sets the property correctly."]

      return


    # PROPFIX -----------------------------------------------------------------

    # SHOESTRING does not have a test for this.

    # REMOVE ------------------------------------------------------------------

    # The REMOVE function removes the current set of elements from the DOM.

    .then ->

      @.evaluate ->

        junction("body").append("<div class='remove'></div>")

        junction(".remove").remove()

      test.assertDoesntExist ".remove", ["REMOVE is successful."]

      return


    # REMOVEATTR --------------------------------------------------------------

    # The REMOVEATTR function removes an attribute from each element in the
    # current set

    .then ->

      before = @.evaluate ->

        junction("body").append("<div class='removeattr' data-foo='bar'></div>")
        return junction(".removeattr")[0]

      after = @.evaluate ->

        junction(".removeattr").removeAttr("data-foo")
        return junction(".removeattr")[0]

      test.assertNotEquals after.attributes[1],
                          before.attributes[1],
                          ["REMOVEATTR removed the attribute"]

      return


    # REMOVECLASS -------------------------------------------------------------

    # The REMOVECLASS function removes the class from the DOM for each element
    # in the set.

    .then ->

      before = @.evaluate ->

        junction("body").append("<div class='removeClass foo'></div>")
        return junction(".removeClass")[0]

      after = @.evaluate ->

        junction(".removeClass").removeClass("foo")
        return junction(".removeClass")[0]

      test.assertNotEquals after.className,
                          before.className,
                          ["REMOVECLASS removed the class."]

      return


    # REMOVEPROP --------------------------------------------------------------

    # The REMOVEPROP function removes a property from each element of the
    # current set.

    .then ->

      before = @.evaluate ->

        junction("body").append("<div class='removeProp'></div>")
        return junction(".removeProp")

      after = @.evaluate ->

        junction(".removeProp").removeProp("class")
        return junction(".removeProp")

      test.assertNotEquals after, before, ["REMOVEPROP removed the property."]

      return


    # REPLACEWITH -------------------------------------------------------------

    # The REPLACEWITH function replaces each element in the current set with
    # the element or string specified.

    # This function doesn't seem to be working. There should be a div with a
    # class of "replacement" but it doesn't exist. Also, it looks like it got
    # rid of the "replaceWith" div, but didn't add the "replacement" one back?

    # From SHOESTRING:

		# <div class="replace-with"></div>

  	# test( '`.replaceWith()`', function() {
  	# 	var $replaceWith = $fixture.find( ".replace-with" );
    #
  	# 	equal( $fixture.find( ".replace-with" ).length, 1 );
    #
  	# 	var old = $replaceWith.replaceWith( "<div class='replacement'></div>" );
    #
  	# 	equal( $fixture.find( ".replace-with" ).length, 0 );
  	# 	equal( $fixture.find( ".replacement" ).length, 1 );
  	# 	ok( old[0].className === "replace-with", "Returned element should be the original element copied" );
  	# });

    .then ->

      before = @.evaluate ->

        junction("body").append("<div class='replaceWith'></div>")
        return junction(".replaceWith")[0]

      after = @.evaluate ->

        testThing = junction(".replaceWith")
        testThing = testThing.replaceWith("<div class='replacement'></div>")
        return junction(".replacement")[0]

      @.echo before.className
      @.echo after

      test.assertNotEquals after, null, ["REPLACEWITH: The after object isn't null"]

      # TODO: When this test passes, write a test to check the before and after.

      return


    # SERIALIZE ---------------------------------------------------------------

    # The SERIALIZE function serializes child input element values into
    # an object

    .then ->

      data = @.evaluate ->

        junction("body").append("<div class='serialize'></div>")

        testThing = junction(".serialize")

        i = 0

        while i < junction.inputTypes.length
          type = junction.inputTypes[i]
          input = "<input type='" + type + "'" + " name='" + type + "'" + " value='" + type + "'></input>"
          testThing.append input
          i++

        otherThing = testThing.serialize()

        return otherThing

      test.assertEquals data["color"], "color", ["SERIALIZE is successful."]

      return


    # SIBLINGS ----------------------------------------------------------------

    # The SIBLINGS function gets all of the sibling elements for each element
    # in the current set.

    .then ->

      siblingCount = @.evaluate ->

        junction("body").append("<div class='siblings'></div>")
        junction(".siblings").append("<div class='siblingOne'></div>")
        junction(".siblings").append("<div class='siblingTwo'></div>")
        junction(".siblings").append("<div class='siblingThree'></div>")

        return junction(".siblingTwo").siblings().length

      test.assertEquals siblingCount, 2, ["SIBLINGS is successful."]

      return


    # TEXT --------------------------------------------------------------------

    # The TEXT function recursively retrieves the text content of each element
    # in the current set.

    .then ->

      containerText = @.evaluate ->

        junction("body").append("<div class='text'>Some Test Text</div>")
        return junction(".text").text()

      testText = "Some Test Text"

      test.assertEquals containerText, testText, ["TEXT is successful."]

      return


    # TOGGLECLASS -------------------------------------------------------------

    # The TOGGLECLASS function should add a class to the selected element if
    # it isn't found or remove the class if it is found.

    # Note: This is only in this library. Not in SHOESTRING.

    .then ->

      before = @.evaluate ->

        junction("body").append("<div class='toggleClass someClass'></div>")
        return junction(".toggleClass").prop("class")

      after = @.evaluate ->

        junction(".toggleClass").toggleClass("someClass")
        return junction(".toggleClass").prop("class")

      test.assertNotEquals before, after, ["TOGGLECLASS removed the class."]

      addClassBack = @.evaluate ->

        junction(".toggleClass").toggleClass("someClass")
        return junction(".toggleClass").prop("class")

      test.assertNotEquals after, addClassBack, ["TOGGLECLASS added the class"]

      return


    # VAL ---------------------------------------------------------------------

    # The VAL function gets the value of the first element or sets the value
    # of all the elements in the current set.

    .then ->

      # Check to see that the function gets the value of the first element
      itemValue = @.evaluate ->

        junction("body").append("<input type='color' name='color' value='blue' class='val'></input>")
        valItem = junction(".val")
        return valItem.val()

      test.assertEquals itemValue, "blue", ["VAL gets a value correctly."]

      # Check to see that the function sets the value on the elements.
      itemSetValue = @.evaluate ->

        valItem = junction(".val")
        valItem.val("orange")
        return valItem.val()

      test.assertEquals itemSetValue, "orange", ["VAL sets a value correctly."]

      return


    # WIDTH -------------------------------------------------------------------

    # The WIDTH function gets the width value of the first element or sets the
    # width for all the elements in the current set.

    .then ->

      widthValue = @.evaluate ->

        junction("body").append("<div class='width'></div>")
        widthItem = junction(".width")
        widthItem.width("400px")
        return widthItem.width()

      test.assertEquals widthValue, 400, ["WIDTH is successful."]

      return


    # WRAPINNER ---------------------------------------------------------------

    # The WRAPINNER function wraps the child elements in the provided HTML

    # TODO: Write a test to check if the function actually wrapped .inner
    # with .wrapper

    .then ->

      @.evaluate ->

        junction("body").append("<div class='wrapinner'></div>")
        junction(".wrapinner").append("<div class='inner'></div>")
        wrapInnerItem = junction(".wrapinner")
        wrapInnerItem.wrapInner("<div class='wrapper'></div>")

      test.assertExists ".wrapper", ["WRAPINNER is successful."]

      return


  casper.run ->
    test.done()
    return

  return
