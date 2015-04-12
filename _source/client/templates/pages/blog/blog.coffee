Template.blogIndex.onRendered = ->
  # Page Title
  document.title = "Blog"
  if Blog.settings.title
    document.title += " | #{Blog.settings.title}"
