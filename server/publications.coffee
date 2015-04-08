Meteor.publishComposite "users", ->
  find: ->
    return false if !Roles.userIsInRole(@userId, ["manage-users"])
    Meteor.users.find({})

Meteor.publishComposite "user", (userId) ->
  find: ->
    return false if @userId isnt userId and !Roles.userIsInRole(@userId, ["manage-users"])
    Meteor.users.find _id: userId

Meteor.publishComposite "examples", ->
  find: ->
    # Would need to restrict access to this with Roles.userIsInRole in real world use
    Examples.find({})

Meteor.publishComposite "example", (slug) ->
  find: ->
    # Would need to restrict access to this with Roles.userIsInRole in real world use
    Examples.find({slug:slug})