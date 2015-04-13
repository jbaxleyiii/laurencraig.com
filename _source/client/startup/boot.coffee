################################################################################
# Client-side Config
#


Blog =
  settings:
    title: ""
    blogIndexTemplate: null
    blogShowTemplate: null
    blogNotFoundTemplate: null
    blogAdminTemplate: null
    blogAdminEditTemplate: null
    pageSize: 20
    excerptFunction: null
    syntaxHighlighting: false
    syntaxHighlightingTheme: "github"
    comments:
      allowAnonymous: true
      useSideComments: true
      defaultImg: "/packages/blog/public/default-user.png"
      userImg: "avatar"
      disqusShortname: "thebaxleys"

  config: (appConfig) ->
    # No deep extend in underscore :-(
    if appConfig.comments
      @settings.comments = _.extend(@settings.comments, appConfig.comments)
      delete appConfig.comments
    @settings = _.extend(@settings, appConfig)

    if @settings.syntaxHighlightingTheme
      $("<link>",
        href: "//cdnjs.cloudflare.com/ajax/libs/highlight.js/8.1/styles/" + @settings.syntaxHighlightingTheme + ".min.css"
        rel: "stylesheet"
      ).appendTo "head"


@Blog = Blog


################################################################################
# Bootstrap Code
#


Meteor.startup ->

  # Load Font Awesome
  $("<link>",
    href: "//netdna.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.css"
    rel: "stylesheet"
  ).appendTo "head"

  # Listen for any "Load More" clicks
  $("body").on "click", ".blog-load-more", (e) ->
    e.preventDefault()
    if Session.get "postLimit"
      Session.set "postLimit", Session.get("postLimit") + Blog.settings.pageSize

  # Notifications package
  _.extend Notifications.defaultOptions,
    timeout: 5000

  window.twttr = do (d = document, s = 'script', id = 'twitter-wjs') ->
    t = undefined
    js = undefined
    fjs = d.getElementsByTagName(s)[0]
    return  if d.getElementById(id)
    js = d.createElement(s)
    js.id = id
    js.src = "https://platform.twitter.com/widgets.js"
    fjs.parentNode.insertBefore js, fjs
    window.twttr or (t =
      _e: []
      ready: (f) ->
        t._e.push f
    )


################################################################################
# Register Global Helpers
#

UI.registerHelper "blogFormatDate", (date) ->
  moment(new Date(date)).format "MMM Do, YYYY"
