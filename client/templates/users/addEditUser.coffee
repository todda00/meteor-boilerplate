Template.addEditUser.rendered = ->
  $(@firstNode).addClass "transitioned"
  return

Template.addEditUser.destroyed = ->
  Session.set "addingUser", false
  Session.set "editingUser", false
  return

Template.addEditUser.helpers
  addingUser: ->
    Session.equals "addingUser", true

  editingUser: ->
    Session.equals "editingUser", true

Template.addEditUser.events
  "submit #addEditUserForm": (e, t) ->
    e.preventDefault()
    clearMsgs()

    form = $(e.target)
    form = processForm(form)

    #Only include roles portion if the user has permissions to edit roles
    if Roles.userIsInRole(Meteor.user(), ["manage-users"])
      rolesForm = processForm($('#editGroupRoles'))
      form.roles = rolesForm.roles || []

    if Session.get("editingUser")
      form.action = 'edit'
      form._id = @_id
    else 
      form.action = 'add'

    Meteor.call 'addEditUser',form, (error, result) ->
      if error
        throwError error.reason
      else
        showMsg(result.message) if result? and result.message?
    		Session.set "addingUser", false

  "click .delete-user": (e, t) ->
    e.preventDefault()
    #Inline Confirmation
    if not e.currentTarget.confirmShown
      $(e.currentTarget).text('Are you Sure?').addClass('btn-danger')
      e.currentTarget.confirmShown = true
      return

    Meteor.call 'removeUser', t.data._id, (error,result) ->
      if error
        throwError error.reason
      else
        Router.go('/users')
