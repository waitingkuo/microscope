Errors = {
    collection: new Meteor.Collection(null),
    "throw": function(message) {
      return Errors.collection.insert({
        message: message,
        seen: false
      });
    },
    clearSeen: function() {
      return Errors.collection.remove({
        seen: true
      });
    }
}
