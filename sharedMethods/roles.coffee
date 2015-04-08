# update a user's permissions

# @param {Object} targetUser of user to update
# @param {Array} roles User's new permissions
# @param {String} group Company to update permissions for

Meteor.methods updateRoles: (targetUser, roles = [], group) ->
  loggedInUser = Meteor.user()
  
  if not loggedInUser or not Roles.userIsInRole(loggedInUser, ["manage-users"], group)
    throw new Meteor.Error('403' , "Access denied")
  Roles.setUserRoles(targetUser, roles, group)

Meteor.methods removeUserFromGroup: (targetUser, group) ->
  loggedInUser = Meteor.user()
  field = 'roles.' + group
  setter = {}
  setter[field] = ""

  if not loggedInUser or not Roles.userIsInRole(loggedInUser, ["manage-users"], group)
    throw new Meteor.Error('403' , "Access denied")

  Meteor.users.update({_id: targetUser}, {$unset: setter})
