###*
@license
Copyright (c) 2014 The Polymer Project Authors. All rights reserved.
This code may only be used under the BSD style license found at http://polymer.github.io/LICENSE.txt
The complete set of authors may be found at http://polymer.github.io/AUTHORS.txt
The complete set of contributors may be found at http://polymer.github.io/CONTRIBUTORS.txt
Code distributed by Google as part of the polymer project is also
subject to an additional IP rights grant found at http://polymer.github.io/PATENTS.txt
###
((global) ->

  # As much as we would like to use the native implementation, IE
  # (all versions) suffers a rather annoying bug where it will drop or defer
  # callbacks when heavy DOM operations are being performed concurrently.
  #
  # For a thorough discussion on this, see:
  # http://codeforhire.com/2013/09/21/setimmediate-and-messagechannel-broken-on-internet-explorer-10/

  # Sadly, this bug also affects postMessage and MessageQueues.
  #
  # We would like to use the onreadystatechange hack for IE <= 10, but it is
  # dangerous in the polyfilled environment due to requiring that the
  # observed script element be in the document.

  # If some other browser ever implements it, let's prefer their native
  # implementation:

  # Otherwise, we fall back to postMessage as a means of emulating the next
  # task semantics of setImmediate.

  # This is used to ensure that we never schedule 2 callas to setImmediate

  # Keep track of observers that needs to be notified next time.

  ###*
  Schedules |dispatchCallback| to be called in the future.
  @param {MutationObserver} observer
  ###
  scheduleCallback = (observer) ->
    scheduledObservers.push observer
    unless isScheduled
      isScheduled = true
      setImmediate dispatchCallbacks
    return
  wrapIfNeeded = (node) ->
    window.ShadowDOMPolyfill and window.ShadowDOMPolyfill.wrapIfNeeded(node) or node
  dispatchCallbacks = ->

    # http://dom.spec.whatwg.org/#mutation-observers
    isScheduled = false # Used to allow a new setImmediate call above.
    observers = scheduledObservers
    scheduledObservers = []

    # Sort observers based on their creation UID (incremental).
    observers.sort (o1, o2) ->
      o1.uid_ - o2.uid_

    anyNonEmpty = false
    observers.forEach (observer) ->

      # 2.1, 2.2
      queue = observer.takeRecords()

      # 2.3. Remove all transient registered observers whose observer is mo.
      removeTransientObserversFor observer

      # 2.4
      if queue.length
        observer.callback_ queue, observer
        anyNonEmpty = true
      return


    # 3.
    dispatchCallbacks()  if anyNonEmpty
    return
  removeTransientObserversFor = (observer) ->
    observer.nodes_.forEach (node) ->
      registrations = registrationsTable.get(node)
      return  unless registrations
      registrations.forEach (registration) ->
        registration.removeTransientObservers()  if registration.observer is observer
        return

      return

    return

  ###*
  This function is used for the "For each registered observer observer (with
  observer's options as options) in target's list of registered observers,
  run these substeps:" and the "For each ancestor ancestor of target, and for
  each registered observer observer (with options options) in ancestor's list
  of registered observers, run these substeps:" part of the algorithms. The
  |options.subtree| is checked to ensure that the callback is called
  correctly.

  @param {Node} target
  @param {function(MutationObserverInit):MutationRecord} callback
  ###
  forEachAncestorAndObserverEnqueueRecord = (target, callback) ->
    node = target

    while node
      registrations = registrationsTable.get(node)
      if registrations
        j = 0

        while j < registrations.length
          registration = registrations[j]
          options = registration.options

          # Only target ignores subtree.
          if node isnt target and not options.subtree
            j++
            continue
          record = callback(options)
          registration.enqueue record  if record
          j++
      node = node.parentNode
    return

  ###*
  The class that maps to the DOM MutationObserver interface.
  @param {Function} callback.
  @constructor
  ###
  JsMutationObserver = (callback) ->
    @callback_ = callback
    @nodes_ = []
    @records_ = []
    @uid_ = ++uidCounter
    return

  # 1.1

  # 1.2

  # 1.3

  # 1.4

  # 2
  # If target's list of registered observers already includes a registered
  # observer associated with the context object, replace that registered
  # observer's options with options.

  # 3.
  # Otherwise, add a new registered observer to target's list of registered
  # observers with the context object as the observer and options as the
  # options, and add target to context object's list of nodes on which it
  # is registered.

  # Each node can only have one registered observer associated with
  # this observer.

  ###*
  @param {string} type
  @param {Node} target
  @constructor
  ###
  MutationRecord = (type, target) ->
    @type = type
    @target = target
    @addedNodes = []
    @removedNodes = []
    @previousSibling = null
    @nextSibling = null
    @attributeName = null
    @attributeNamespace = null
    @oldValue = null
    return
  copyMutationRecord = (original) ->
    record = new MutationRecord(original.type, original.target)
    record.addedNodes = original.addedNodes.slice()
    record.removedNodes = original.removedNodes.slice()
    record.previousSibling = original.previousSibling
    record.nextSibling = original.nextSibling
    record.attributeName = original.attributeName
    record.attributeNamespace = original.attributeNamespace
    record.oldValue = original.oldValue
    record

  # We keep track of the two (possibly one) records used in a single mutation.

  ###*
  Creates a record without |oldValue| and caches it as |currentRecord| for
  later use.
  @param {string} oldValue
  @return {MutationRecord}
  ###
  getRecord = (type, target) ->
    currentRecord = new MutationRecord(type, target)

  ###*
  Gets or creates a record with |oldValue| based in the |currentRecord|
  @param {string} oldValue
  @return {MutationRecord}
  ###
  getRecordWithOldValue = (oldValue) ->
    return recordWithOldValue  if recordWithOldValue
    recordWithOldValue = copyMutationRecord(currentRecord)
    recordWithOldValue.oldValue = oldValue
    recordWithOldValue
  clearRecords = ->
    currentRecord = recordWithOldValue = `undefined`
    return

  ###*
  @param {MutationRecord} record
  @return {boolean} Whether the record represents a record from the current
  mutation event.
  ###
  recordRepresentsCurrentMutation = (record) ->
    record is recordWithOldValue or record is currentRecord

  ###*
  Selects which record, if any, to replace the last record in the queue.
  This returns |null| if no record should be replaced.

  @param {MutationRecord} lastRecord
  @param {MutationRecord} newRecord
  @param {MutationRecord}
  ###
  selectRecord = (lastRecord, newRecord) ->
    return lastRecord  if lastRecord is newRecord

    # Check if the the record we are adding represents the same record. If
    # so, we keep the one with the oldValue in it.
    return recordWithOldValue  if recordWithOldValue and recordRepresentsCurrentMutation(lastRecord)
    null

  ###*
  Class used to represent a registered observer.
  @param {MutationObserver} observer
  @param {Node} target
  @param {MutationObserverInit} options
  @constructor
  ###
  Registration = (observer, target, options) ->
    @observer = observer
    @target = target
    @options = options
    @transientObservedNodes = []
    return
  registrationsTable = new WeakMap()
  setImmediate = undefined
  if /Trident|Edge/.test(navigator.userAgent)
    setImmediate = setTimeout
  else if window.setImmediate
    setImmediate = window.setImmediate
  else
    setImmediateQueue = []
    sentinel = String(Math.random())
    window.addEventListener "message", (e) ->
      if e.data is sentinel
        queue = setImmediateQueue
        setImmediateQueue = []
        queue.forEach (func) ->
          func()
          return

      return

    setImmediate = (func) ->
      setImmediateQueue.push func
      window.postMessage sentinel, "*"
      return
  isScheduled = false
  scheduledObservers = []
  uidCounter = 0
  JsMutationObserver:: =
    observe: (target, options) ->
      target = wrapIfNeeded(target)
      throw new SyntaxError()  if not options.childList and not options.attributes and not options.characterData or options.attributeOldValue and not options.attributes or options.attributeFilter and options.attributeFilter.length and not options.attributes or options.characterDataOldValue and not options.characterData
      registrations = registrationsTable.get(target)
      registrationsTable.set target, registrations = []  unless registrations
      registration = undefined
      i = 0

      while i < registrations.length
        if registrations[i].observer is this
          registration = registrations[i]
          registration.removeListeners()
          registration.options = options
          break
        i++
      unless registration
        registration = new Registration(this, target, options)
        registrations.push registration
        @nodes_.push target
      registration.addListeners()
      return

    disconnect: ->
      @nodes_.forEach ((node) ->
        registrations = registrationsTable.get(node)
        i = 0

        while i < registrations.length
          registration = registrations[i]
          if registration.observer is this
            registration.removeListeners()
            registrations.splice i, 1
            break
          i++
        return
      ), this
      @records_ = []
      return

    takeRecords: ->
      copyOfRecords = @records_
      @records_ = []
      copyOfRecords

  currentRecord = undefined
  recordWithOldValue = undefined
  Registration:: =
    enqueue: (record) ->
      records = @observer.records_
      length = records.length

      # There are cases where we replace the last record with the new record.
      # For example if the record represents the same mutation we need to use
      # the one with the oldValue. If we get same record (this can happen as we
      # walk up the tree) we ignore the new record.
      if records.length > 0
        lastRecord = records[length - 1]
        recordToReplaceLast = selectRecord(lastRecord, record)
        if recordToReplaceLast
          records[length - 1] = recordToReplaceLast
          return
      else
        scheduleCallback @observer
      records[length] = record
      return

    addListeners: ->
      @addListeners_ @target
      return

    addListeners_: (node) ->
      options = @options
      node.addEventListener "DOMAttrModified", this, true  if options.attributes
      node.addEventListener "DOMCharacterDataModified", this, true  if options.characterData
      node.addEventListener "DOMNodeInserted", this, true  if options.childList
      node.addEventListener "DOMNodeRemoved", this, true  if options.childList or options.subtree
      return

    removeListeners: ->
      @removeListeners_ @target
      return

    removeListeners_: (node) ->
      options = @options
      node.removeEventListener "DOMAttrModified", this, true  if options.attributes
      node.removeEventListener "DOMCharacterDataModified", this, true  if options.characterData
      node.removeEventListener "DOMNodeInserted", this, true  if options.childList
      node.removeEventListener "DOMNodeRemoved", this, true  if options.childList or options.subtree
      return


    ###*
    Adds a transient observer on node. The transient observer gets removed
    next time we deliver the change records.
    @param {Node} node
    ###
    addTransientObserver: (node) ->

      # Don't add transient observers on the target itself. We already have all
      # the required listeners set up on the target.
      return  if node is @target
      @addListeners_ node
      @transientObservedNodes.push node
      registrations = registrationsTable.get(node)
      registrationsTable.set node, registrations = []  unless registrations

      # We know that registrations does not contain this because we already
      # checked if node === this.target.
      registrations.push this
      return

    removeTransientObservers: ->
      transientObservedNodes = @transientObservedNodes
      @transientObservedNodes = []
      transientObservedNodes.forEach ((node) ->

        # Transient observers are never added to the target.
        @removeListeners_ node
        registrations = registrationsTable.get(node)
        i = 0

        while i < registrations.length
          if registrations[i] is this
            registrations.splice i, 1

            # Each node can only have one registered observer associated with
            # this observer.
            break
          i++
        return
      ), this
      return

    handleEvent: (e) ->

      # Stop propagation since we are managing the propagation manually.
      # This means that other mutation events on the page will not work
      # correctly but that is by design.
      e.stopImmediatePropagation()
      switch e.type
        when "DOMAttrModified"

          # http://dom.spec.whatwg.org/#concept-mo-queue-attributes
          name = e.attrName
          namespace = e.relatedNode.namespaceURI
          target = e.target

          # 1.
          record = new getRecord("attributes", target)
          record.attributeName = name
          record.attributeNamespace = namespace

          # 2.
          oldValue = (if e.attrChange is MutationEvent.ADDITION then null else e.prevValue)
          forEachAncestorAndObserverEnqueueRecord target, (options) ->

            # 3.1, 4.2
            return  unless options.attributes

            # 3.2, 4.3
            return  if options.attributeFilter and options.attributeFilter.length and options.attributeFilter.indexOf(name) is -1 and options.attributeFilter.indexOf(namespace) is -1

            # 3.3, 4.4
            return getRecordWithOldValue(oldValue)  if options.attributeOldValue

            # 3.4, 4.5
            record

        when "DOMCharacterDataModified"

          # http://dom.spec.whatwg.org/#concept-mo-queue-characterdata
          target = e.target

          # 1.
          record = getRecord("characterData", target)

          # 2.
          oldValue = e.prevValue
          forEachAncestorAndObserverEnqueueRecord target, (options) ->

            # 3.1, 4.2
            return  unless options.characterData

            # 3.2, 4.3
            return getRecordWithOldValue(oldValue)  if options.characterDataOldValue

            # 3.3, 4.4
            record

        when "DOMNodeRemoved"
          @addTransientObserver e.target

        # Fall through.
        when "DOMNodeInserted"

          # http://dom.spec.whatwg.org/#concept-mo-queue-childlist
          target = e.relatedNode
          changedNode = e.target
          addedNodes = undefined
          removedNodes = undefined
          if e.type is "DOMNodeInserted"
            addedNodes = [changedNode]
            removedNodes = []
          else
            addedNodes = []
            removedNodes = [changedNode]
          previousSibling = changedNode.previousSibling
          nextSibling = changedNode.nextSibling

          # 1.
          record = getRecord("childList", target)
          record.addedNodes = addedNodes
          record.removedNodes = removedNodes
          record.previousSibling = previousSibling
          record.nextSibling = nextSibling
          forEachAncestorAndObserverEnqueueRecord target, (options) ->

            # 2.1, 3.2
            return  unless options.childList

            # 2.2, 3.3
            record

      clearRecords()
      return

  global.JsMutationObserver = JsMutationObserver
  global.MutationObserver = JsMutationObserver  unless global.MutationObserver
  return
) this
