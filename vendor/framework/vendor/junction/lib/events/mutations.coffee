do ->
  MutationObsever = window.MutationObserver or window.WebKitMutationObserver

  if !MutationObsever
    return

  mutationHandler = (mutations) ->

    for changed in mutations

      whiteList = ["HEAD", "HTML", "BODY", "TITLE", "SCRIPT"]

      if (
        whiteList.indexOf(changed.target.nodeName) > -1 or
        changed.addedNodes.length is 0
      )
        continue

      junction.updateModels changed.target


  myObserver = new MutationObsever mutationHandler

  obsConfig =
    childList: true
    characterData: true
    attributes: true
    subtree: true

  myObserver.observe(document, obsConfig)


  return
