Template.users.helpers addingUser: ->
  Session.equals "addingUser", true

Template.users.events "click .add-user, click .cancel": (e, t) ->
  Session.set "addingUser", not Session.get("addingUser")
  return
