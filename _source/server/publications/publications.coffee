
#
# Public Publications
#


Meteor.publish 'singlePostBySlug', (slug) ->
  check slug, String

  # singlePost = Post.find slug: slug

  allDatesandSlugs = Post.find( { published: true },
    sort: publishedAt: -1
  )


  return [
    allDatesandSlugs
    # allDatesandSlugs
  ]


Meteor.publish 'posts', (limit) ->

  check limit, Match.OneOf(Number, null)

  if limit is null then return @ready()

  Post.find { published: true },
    fields: body: 0
    sort: publishedAt: -1
    limit: limit



Meteor.publish 'authors', ->
  ids = _.uniq(_.pluck(Post.all(fields: userId: 1), 'userId'))

  Author.find
    _id: $in: ids
  ,
    fields:
      profile: 1
      username: 1
      emails: 1


#
# Admin Publications
#

Meteor.publish 'singlePostById', (id) ->
  check id, String

  if not @userId
    return @ready()

  Post.find _id: id


Meteor.publish 'postForAdmin', ->
  if not @userId
    return @ready()

  sel = {}

  # If author role is set, and user is author, only return user's posts
  if Blog.settings.authorRole and Roles.userIsInRole(@userId, Blog.settings.authorRole)
    sel = userId: @userId

  Post.find sel,
    fields: body: 0
    sort: publishedAt: -1
