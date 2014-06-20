Meteor.startup ->
  Template.comment.helpers
    submittedText: ->
      new Date(@submitted).toString()
