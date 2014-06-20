Meteor.startup ->

  POST_HEIGHT = 80
  Position = new Meteor.Collection null

  Template.postItem.helpers
    domain: ->
      a = document.createElement 'a'
      a.href = @url
      a.hostname

    ownPost: ->
      @userId == Meteor.userId()

    upvotedClass: ->
      userId = Meteor.userId()
      if userId and not _.include(@upvoters, userId)
        return 'btn-primary upvotable'
      else
        return 'btn-default disabled'

    attributes: ->
      post = _.extend {}, Positions.findOne({postId: @_id}), @
      newPosition = post._rank * POST_HEIGHT
      attributes = {}


  Template.postItem.events
    'click .upvote': (e) ->
      e.preventDefault()
      Meteor.call 'upvote', @_id
