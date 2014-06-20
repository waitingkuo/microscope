Meteor.startup ->
  Template.layout.helpers
    pageTitle: ->Session.get 'pageTitle'
