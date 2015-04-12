
casper.test.begin "Event Methods Testing", 5, (test) ->

	casper.start()

		# BIND ----------------------------------------------------------------------

		# The BIND event binds a callback to an event for the current set of
		# elements.

		.then ->

			testThing = @.evaluate ->

				junction("body").append("<div id='bindTest'></div>")
				junction("#bindTest").bind("click", () ->
					# __utils__.echo "bindTest click"
					junction("#bindTest").addClass("bindTest")
				)
				return junction("#bindTest")

			i = 1
			@.click("#" + testThing[0].id)

			test.assertExists ".bindTest", ["BIND is successful."]

			return


		# No CLICK method?

		# IE10SUPPORT ---------------------------------------------------------------
		# No idea how or if we need to test this.

		# MUTATIONS -----------------------------------------------------------------
		# No idea how or if we need to test this.

		# ONE -----------------------------------------------------------------------

		# The ONE event will bind a callback to an event for the current set of
		# elements and then unbind after one occurence.

		.then ->

			testThing = @.evaluate ->

				junction("body").append("<div id='oneTest'></div>")
				__utils__.echo junction("#oneTest")	# <--- this is an HTMLDivElement
				junction("#oneTest").one("click", () ->
					__utils__.echo "oneTest click"
					junction("#oneTest").addClass("oneTest")
				)
				__utils__.echo junction("#oneTest")	# <--- this should be an HTMLDivElement
				return junction("#oneTest")

			@.echo "This is failing because after calling .one() on the #oneTest"
			@.echo "object, it is null. It should be returning an HTMLDivElement."
			@.echo testThing
			@.echo "first click"
			@.click("#" + testThing[0].id)
			@.echo "in between clicks"
			@.click("#" + testThing[0].id)
			@.echo "end of clicks"

			test.assertExists ".oneTest", ["ONE is successful."]

			return


		# TRIGGER -------------------------------------------------------------------

		# The TRIGGER event actually triggers an event on each of the DOM elements
		# in the current set.

		.then ->

			@.evaluate ->

				junction("body").append("<div id='triggerTest'></div>")
				junction("#triggerTest").bind("click", () ->
					__utils__.echo "triggerTest click"
					junction("#triggerTest").addClass("triggerTest")
				)

			@.evaluate ->

				junction("#triggerTest").trigger("click")

			test.assertExists ".triggerTest", ["TRIGGER is successful."]

			return


		# TRIGGERHANDLER ------------------------------------------------------------

		# The TRIGGERHANDLER event triggers an event on the first element in the
		# set.

		.then ->

			@.evaluate ->

				junction("body").append("<div id='triggerHandler'></div>")
				junction("#triggerHandler").append("<div id='triggerHandler1'></div>")
				junction("#triggerHandler").append("<div id='triggerHandler2'></div>")
				junction("#triggerHandler1").bind("click", () ->
					__utils__.echo "triggerHandler1 click"
					junction("#triggerHandler1").addClass("triggerHandler1")
				)
				junction("#triggerHandler2").bind("click", () ->
					__utils__.echo "triggerHandler2 click"
					junction("#triggerHandler2").addClass("triggerHandler2")
				)

			@.evaluate ->

				theKids = junction("#triggerHandler").children()
				__utils__.echo theKids.length
				theKids.each ->
					__utils__.echo @.id
				theKids.triggerHandler("click")

			test.assertExists ".triggerHandler1", ["TRIGGERHANDLER is successful."]

			return


		# UNBIND --------------------------------------------------------------------

		# The UNBIND event unbinds a previously bound callback for an event.

		.then ->

			testThing = @.evaluate ->

				junction("body").append("<div id='unbindTest'></div>")
				junction("#unbindTest").bind("click", () ->
					__utils__.echo "unbindTest click"
					junction("#unbindTest").addClass("unbindTest")
				)
				__utils__.echo junction("#unbindTest")
				junction("#unbindTest").unbind("click")
				__utils__.echo junction("#unbindTest") # <--- This should be an HTMLDivElement
				return junction("#unbindTest")

			@.echo "junction('#unbindTest') is returning null after calling .unbind()"
			@.echo testThing
			@.click("#" + testThing[0].id)

			assertDoesntExist ".unbindTest", ["UNBIND is successful."]

			return


	casper.run ->
	  test.done()
	  return

	return
