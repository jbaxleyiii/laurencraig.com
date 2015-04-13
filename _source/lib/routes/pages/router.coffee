
Router.configure
  progressSpinner: false
  layoutTemplate: "custom"
  loadingTemplate: "loading"
  notFoundTemplate: "blogIndex"
  load: ->
    if Meteor.isClient
      $('html, body').animate({ scrollTop: 0 }, 400)


if Meteor.isClient

  Transitioner.default
    # in: ["transition.slideLeftIn", { duration: 500 }]
    # out: ["transition.slideLeftOut", { duration: 500 }]
    in: (node, next) ->
      $node = $(node)
      $.Velocity.hook($node, "translateX", "100%");
      $node.insertBefore(next)
        .velocity {
            opacity: [ 1, 0 ]
            translateX: [ 0, -80 ]
            translateZ: 0
          },
          duration: 500
          easing: 'ease-in-out'
          queue: false

    out: (node) ->
      $node = $(node)
      $node.velocity {
          opacity: [ 0, 1 ]
          translateX: -80
          translateZ: 0
        },
        reset: { translateX: 0 }
        duration: 500
        easing: 'ease-in-out'
        queue: false
        complete: ->
          $node.remove()


subs = new SubsManager
  cacheLimit: 10, # Maximum number of cache subscriptions
  expireIn: 5 # Any subscription will be expire after 5 minute, if it"s not subscribed again


Router.map ->

  @.route "/",
    name: "blogIndex"
    template: "blogIndex"
    fastRender: true

    onBeforeAction: ->
      $('html, body').animate({ scrollTop: 0 }, 400)
      @next()

  @.route "/admin",
    name: "administration"
    template: "administration"


  # NEW/EDIT BLOG

  @.route "/admin/edit/:id",
    name: "blogAdminEdit"
    template: "blogAdminEdit"

    onBeforeAction: ->
      if Meteor.loggingIn()
        return

      Deps.autorun () ->
        if not Meteor.userId()
          Router.go "blogIndex"

      Meteor.call "isBlogAuthorized", @params.id, (err, authorized) =>
        if not authorized
          return @redirect("/blog")

      Session.set "postId", @params.id

      if Session.get("postId").length?
        @next()

  @.route "/admin/profile",
    name: "profile"
    template: "profile"

    onBeforeAction: ->
      if Meteor.loggingIn()
        return

      Deps.autorun () ->
        if not Meteor.userId()
          Router.go "blogIndex"

      Meteor.call "isBlogAuthorized", @params.id, (err, authorized) =>
        if not authorized
          return @redirect("/blog")

      @next()



  @.route "/:slug",
    name: "blogShow"
    template: "blogShow"

    onBeforeAction: ->
      $('html, body').animate({ scrollTop: 0 }, 400)
      @next()


    onRun: ->
      Session.set("slug", @params.slug)
      @next()

    action: ->

      if @ready()

        @render()

    waitOn: ->
      [
        Meteor.subscribe "singlePostBySlug"
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
