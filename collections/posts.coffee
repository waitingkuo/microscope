@Posts = new Meteor.Collection 'posts'

Posts.allow
  update: ownsDocument
  remove: ownsDocument

Posts.deny
  update: (userId, post, fieldNames) ->
    return (_.without(fieldNames, 'url', 'title').lenth > 0)


Meteor.methods

  post: (postAttributes) ->

    user = Meteor.user()
    postWithSameLink = Posts.findOne {url: postAttributes.url}

    if not user
      Errors.throw new Meteor.Error 401, 'You need to login to post new stories'

    if not postAttributes.title
      Errors.throw new Meteor.Error 422, 'Please fill in a headline'

    if postAttributes.url and postWithSameLink
      Errors.throw new Meteor.Error 302, 'This link has already been posted', postWithSameLink._id

    post = _.extend _.pick(postAttributes, 'url', 'title', 'message'),
      #title: postAttributes.title + (if @isSimulation then '(client)' else '(server)')
      userId: user._id
      author: user.username
      submitted: new Date().getTime()
      commentsCount: 0
      upvoters: []
      votes: 0

    #if not @isSimulation
    #  Future = Npm.require 'fibers/future'
    #  future = new Future()
    #  Meteor.setTimeout (->
    #    future.return()
    #  ), 2* 1000
    #  future.wait()

    postId = Posts.insert post

    return postId

  upvote: (postId) ->
    
    user = Meteor.user()
    if not user
      Errors.throw new Meteor.Error(401, 'You need to login to upvote')
      return

    Posts.update {
      _id: postId
      upvoters: {$ne: user._id}
    }, {
      $addToSet: {upvoters: user._id}
      $inc: {votes: 1}
    }


