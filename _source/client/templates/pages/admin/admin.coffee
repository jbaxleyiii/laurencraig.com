Template.administration.onCreated ->

  @.subscribe "postForAdmin"
  @.subscribe "authors"

Template.administration.helpers

  posts: ->
    # Call toArray() because minimongoid does not return a true array, and
    # reactive-table expects a true array (or collection)
    results = Post.all(sort: updatedAt: -1).toArray()

    # if _.size Session.get 'filters'
    #   results = _(results).where Session.get('filters')

    results



Template.administration.events

  'click .for-new-blog': (e, tpl) ->
    e.preventDefault()

    Router.go 'blogAdminEdit', id: Random.id()

  'click #logout': (e, tpl) ->
    e.preventDefault()

    Meteor.logout()
