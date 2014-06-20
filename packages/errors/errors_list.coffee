Template.meteorErrors.helpers
  errors: ->
    window.Errors.collection.find()

Template.meteorError.rendered = ->
  error = @data
  Meteor.defer ->
    window.Errors.collection.update error._id, 
      $set: {seen: true}

