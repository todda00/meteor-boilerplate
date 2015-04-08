Meteor.methods addEditUser: (form) ->
  @unblock()

  fields =
    firstName: String
    lastName: String
    email: Match.Optional(String)
    roles: Match.Optional([String])

  check(form,Match.ObjectIncluding(fields))

  if form.action is "edit"
    
    check(form._id,String)

    #load the user and check if the acting user can edit them
    user = Meteor.users.findOne({_id:form._id})

    pass = false
    #Users can edit themselves
    if user._id == Meteor.userId()
      pass = true

    #Global admins can edit
    if Roles.userIsInRole(Meteor.user(), ['manage-users'], Roles.GLOBAL_GROUP)
      pass = true

    if !pass
      actingUserGroups = Roles.getGroupsForUser(Meteor.user(),'manage-users')
      editingUserGroups = _.keys(user.roles)

      compare = _.intersection(actingUserGroups,editingUserGroups)
      if compare.length > 1
        pass = true

    if !pass
      throw new Meteor.Error('403' , "Access denied")
      return

    setForm =
      'profile.firstName': form.firstName
      'profile.lastName': form.lastName
    Meteor.users.update form._id,
      $set: setForm
      , (error, result) ->
        throwError error.message if error
    
    if form.roles?
      Meteor.call "updateRoles", user._id, form.roles
    return


  if form.action is "add"
    
    if !Roles.userIsInRole(Meteor.user(), ['manage-users'], form.practice)
      throw new Meteor.Error('403' , "Access denied")
      return

    options =
      email: form.email
      profile:
        firstName: form.firstName
        lastName: form.lastName

    userId = Accounts.createUser(options)
    
    return if !userId?

    Meteor.call "updateRoles", userId, form.roles
    Accounts.sendEnrollmentEmail(userId, form.email)