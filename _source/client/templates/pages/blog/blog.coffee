Template.blogIndex.onRendered ->


  # Page Title
  document.title = "Lauren Craig"
  # if Blog.settings.title
  #   document.title += " | #{Blog.settings.title}"

Template.blogIndexLoop.onCreated ->

  if not Session.get("postLimit") and Blog.settings.pageSize
    Session.set "postLimit", Blog.settings.pageSize

  @.subscribe "posts", 20
  @.subscribe "authors"


Template.blogIndexLoop.helpers

  posts: ->
    return Post.where {},
      sort: publishedAt: -1
