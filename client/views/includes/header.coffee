Meteor.startup ->
  Template.header.helpers
    activeRouteClass: ->
      args = Array.prototype.slice.call(arguments, 0)
      args.pop()

      active = _.any args, (name) ->
        return Router.current() and Router.current().route.name is name

      return active and 'active'
