Meteor.methods 
  removeUser: (userId) ->
    @unblock()

    check(userId,String)

    user = Meteor.users.findOne({_id:userId})
    return if !user? 

    #Delete the user if the requesting user is a global admin
    if Roles.userIsInRole(Meteor.user(), ['manage-users'], Roles.GLOBAL_GROUP)  
      Meteor.users.remove({_id: user._id})
      return

  addSelfAdmin: () ->
    @unblock()
    if Meteor.users.find({}).count() is 1
      Roles.setUserRoles(Meteor.user(), ['manage-users'])
      if @isSimulation
        Router.go('user',{_id:Meteor.userId})

  countUsers: () ->
    @unblock()
    return Meteor.users.find({}).count()