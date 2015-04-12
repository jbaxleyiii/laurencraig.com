Meteor.startup ->
  hljs.initHighlightingOnLoad()
  
  ((kitID) ->
    config = kitId: kitID
    d = false
    tk = document.createElement('script')
    tk.src = '//use.typekit.net/' + config.kitId + '.js'
    tk.type = 'text/javascript'
    tk.async = 'true'
    tk.onload =
    tk.onreadystatechange = ->
      rs = @readyState
      if d or rs and rs != 'complete' and rs != 'loaded'
        return
      d = true
      try
        Typekit.load config
      catch e
      return

    s = document.getElementsByTagName('script')[0]
    s.parentNode.insertBefore tk, s
    return
  ) "ice7qhs"
