


Template.blogShow.helpers

  isAdmin: ->
    Session.get "canEditPost"




Template.blogShow.onRendered ->
  console.log "blogShow is rendered"

  # Page Title
  document.title = "Lauren Craig"
  # if Blog.settings.title
  #   document.title += " | #{Blog.settings.title}"


  Meteor.call "isBlogAuthorized", @id, (err, authorized) =>
    if authorized
      Session.set "canEditPost", authorized


Template.pinterest.onRendered ->

    return unless @data

    @autorun ->
      template = Template.instance()
      data = Template.currentData()

      preferred_url = data.url || location.origin + location.pathname
      url = encodeURIComponent preferred_url
      description = encodeURIComponent data.pinterest?.description || data.description

      href = "http://www.pinterest.com/pin/create/button/?url=#{url}&media=#{data.media}&description=#{description}"

      template.$('[data-share]').attr 'href', href

Template.twitter.onRendered ->

    return unless @data

    @autorun ->
      template = Template.instance()
      data = Template.currentData()
      $('meta[property^="twitter:"]').remove()

      if data.thumbnail
        if typeof data.thumbnail is "function"
          img = data.thumbnail()
        else
          img = data.thumbnail
        if img
          if not /^http(s?):\/\/+/.test(img)
            img = location.origin + img

      #
      # Twitter cards
      #

      $('<meta>', { property: 'twitter:card', content: 'summary' }).appendTo 'head'
      # What should go here?
      #$('<meta>', { property: 'twitter:site', content: '' }).appendTo 'head'

      # if data.author
      $('<meta>', { property: 'twitter:creator', content: "laurnec" }).appendTo 'head'

      description = data.excerpt || data.description

      $('<meta>', { property: 'twitter:url', content: location.origin + location.pathname }).appendTo 'head'
      $('<meta>', { property: 'twitter:title', content: "#{data.title}" }).appendTo 'head'
      $('<meta>', { property: 'twitter:description', content: description }).appendTo 'head'
      $('<meta>', { property: 'twitter:image', content: img }).appendTo 'head'

      #
      # Twitter share button
      #

      preferred_url = data.url || location.origin + location.pathname
      url = encodeURIComponent preferred_url

      base = "https://twitter.com/intent/tweet"
      text = encodeURIComponent data.twitter?.title || data.title
      href = base + "?url=" + url + "&text=" + text

      # if data.author
      href += "&via=" + "laurnec"

      template.$("[data-share]").attr "href", href



Template.facebook.onRendered ->

  return unless @data

  @autorun ->
    template = Template.instance()
    data = Template.currentData()

    $('meta[property^="og:"]').remove()
    #
    # OpenGraph tags
    #
    description = data.facebook?.description || data.excerpt || data.description || data.summary
    url = data.url || location.origin + location.pathname
    title = data.title
    $('<meta>', { property: 'og:type', content: 'article' }).appendTo 'head'
    $('<meta>', { property: 'og:site_name', content: location.hostname }).appendTo 'head'
    $('<meta>', { property: 'og:url', content: url }).appendTo 'head'
    $('<meta>', { property: 'og:title', content: title }).appendTo 'head'
    $('<meta>', { property: 'og:description', content: description }).appendTo 'head'

    if data.thumbnail
        if typeof data.thumbnail == "function"
            img = data.thumbnail()
        else
            img = data.thumbnail
    if img
        if not /^http(s?):\/\/+/.test(img)
            img = location.origin + img

    $('<meta>', { property: 'og:image', content: img }).appendTo 'head'

    url = encodeURIComponent url
    base = "https://www.facebook.com/sharer/sharer.php"
    title = encodeURIComponent title
    summary = encodeURIComponent description
    href = base + "?s=100&p[url]=" + url + "&p[title]=" + title + "&p[summary]=" + summary
    if img
        href += "&p[images][0]=" + encodeURIComponent img

    template.$("[data-share]").attr "href", href




Template.blogShow.events
  "click a#edit-post": (event, template) ->
    event.preventDefault()
    postId = Post.first({slug: Router.current().params.slug})._id
    Router.go "blogAdminEdit", {id: postId}




Template.disqus.onRendered ->

  if Blog.settings.comments.disqusShortname
    # Don"t load the Disqus embed.js into the DOM more than once
    if window.DISQUS
      # If we"ve already loaded, call reset instead. This will find the correct
      # thread for the current page URL. See:
      # http://help.disqus.com/customer/portal/articles/472107-using-disqus-on-ajax-sites
      post = @data

      window.DISQUS.reset
        reload: true
        config: ->
          @page.identifier = post.id
          @page.title = post.title
          @page.url = window.location.href
    else
      disqus_shortname = Blog.settings.comments.disqusShortname
      disqus_identifier = @data.id
      disqus_title = @data.title
      disqus_url = window.location.href
      disqus_developer = 1

      dsq = document.createElement("script")
      dsq.type = "text/javascript"
      dsq.async = true
      dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js"
      (document.getElementsByTagName("head")[0] or document.getElementsByTagName("body")[0]).appendChild dsq


Template.disqus.helpers
  useDisqus: ->
    Blog.settings.comments.disqusShortname
