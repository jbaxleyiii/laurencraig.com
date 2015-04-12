# Router.route "/",
#   name: "blog-admin"
#   template: "blog-admin"
Router.configure
  progressSpinner: false



subs = new SubsManager
  cacheLimit: 10, # Maximum number of cache subscriptions
  expireIn: 5 # Any subscription will be expire after 5 minute, if it"s not subscribed again


if Meteor.isClient


  Router.onBeforeAction ->
    @notFoundTemplate =
      if Blog.settings.blogNotFoundTemplate
        Blog.settings.blogNotFoundTemplate
      else
        "blogNotFound"
    Iron.Router.hooks.dataNotFound.call @
  , only: ["blogShow"]


# BLOG INDEX

Router.route "/",
  name: "blogIndex"
  template: "custom"
  onRun: ->

    if not Session.get("postLimit") and Blog.settings.pageSize
      Session.set "postLimit", Blog.settings.pageSize

    @next()

  waitOn: ->
    if (typeof Session isnt "undefined")
      [
        subs.subscribe "posts", Blog.settings.pageSize
        subs.subscribe "authors"
      ]

  fastRender: true

  data: ->
    posts: Post.where {},
      sort: publishedAt: -1


# SHOW BLOG

# BLOG ADMIN INDEX

Router.route "/admin/",
  name: "blog-admin"
  template: "custom"

  waitOn: ->
    [
      Meteor.subscribe "postForAdmin"
      Meteor.subscribe "authors"
    ]

# NEW/EDIT BLOG

Router.route "/admin/edit/:id",
  name: "blogAdminEdit"
  template: "custom"

  onBeforeAction: ->
    if Meteor.loggingIn()
      return

    Deps.autorun () ->
      Router.go "blogIndex" if not Meteor.userId()

    Meteor.call "isBlogAuthorized", @params.id, (err, authorized) =>
      if not authorized
        return @redirect("/blog")

    Session.set "postId", @params.id

    if Session.get("postId").length?
      @next()

  action: ->

    if @ready()
      @render()

  waitOn: -> [
    Meteor.subscribe "singlePostById", @params.id
    Meteor.subscribe "authors"
  ]




Router.route "/:slug",
  name: "blogShow"
  template: "custom"

  onRun: ->
    Session.set("slug", @params.slug)
    @next()

  onBeforeAction: ->

    if !Blog.settings.publicDrafts and !Post.first().published
      Meteor.call "isBlogAuthorized", (err, authorized) =>
        if not authorized
          return @redirect("/blog")

    @next()
  action: ->
    if @ready()

      @render()

  waitOn: ->
    [
      Meteor.subscribe "singlePostBySlug", @params.slug
      subs.subscribe "authors"
    ]
  fastRender: true

  data: ->
    _post = Post.first slug: @params.slug

    allPosts = Post.all({
      fields:
        slug: 1
        id: 1
      sort: {
        publishedAt: -1
      }
    }).toArray()

    postIndex = false
    for post, index in allPosts
      if post.id is _post.id
        postIndex = index
        break


    if postIndex isnt false
      if allPosts[postIndex - 1]
        _post.prevPost = allPosts[postIndex - 1]

      if allPosts[postIndex + 1]
        _post.nextPost = allPosts[postIndex + 1]


    return _post
