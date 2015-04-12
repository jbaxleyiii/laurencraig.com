
Template.blogAdmin.onCreated ->

  @.subscribe "postForAdmin"
  @.subscribe "authors"

Template.blogAdmin.helpers

  posts: ->
    # Call toArray() because minimongoid does not return a true array, and
    # reactive-table expects a true array (or collection)
    results = Post.all(sort: updatedAt: -1).toArray()

    # if _.size Session.get 'filters'
    #   results = _(results).where Session.get('filters')

    results


Template.blogAdmin.events

  'click .for-new-blog': (e, tpl) ->
    e.preventDefault()

    Router.go 'blogAdminEdit', id: Random.id()


Template.blogEntry.events

  'click .for-publish': (e, tpl) ->
    e.preventDefault()
    @update
      published: true
      publishedAt: new Date()

  'click .for-unpublish': (e, tpl) ->
    e.preventDefault()
    @update
      published: false
      publishedAt: null

  'click .delete': (e, tpl) ->
    e.preventDefault()

    if confirm('Are you sure?')
      @destroy()
