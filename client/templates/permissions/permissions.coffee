Template.permissions.rendered = ->
  #used for autocomplete to add a user to a practice
  Session.set "currentUserId", @data._id
  return

Template.permissions.helpers
  globalRoles: ->
    [
      {
        value: "manage-users"
        display: "Manage Users"
        details: "Add, edit, remove, and set permissions for users."
      }
    ]

  autoCompleteSettings: ->
    position: "top"
    limit: 5
    rules: [
      collection: Practices
      field: "name"
      template: Template.practiceName
      matchAll: true
      callback: (doc, element) ->
      	#TODO Check if user is already in this practice and do not wipe out permissions
        Meteor.call "updateRoles", Session.get("currentUserId"), [], doc._id
        $("#groupAutocomplete").val("")
        return
    ]

  showAddGlobal: ->
    targetUser = @_id
    loggedInUser = Meteor.user()
    #Don't show if user is already in global, or the logged in user doesn't have permission to add this user to global
    groups = Object.keys(@roles)
    return true if Roles.userIsInRole(loggedInUser, ["manage-users"], Roles.GLOBAL_GROUP) and Roles.GLOBAL_GROUP not in groups
    return false

  attrsPractice: ->
    "data-practice": @name

Template.permissions.events
  "click .edit-group-roles": (e, t) ->
    #pull the practice ID from the button
    practiceId = $(e.currentTarget).attr('data-practice')
    data = {}
    data.practiceId = practiceId
    data.roles = t.data.roles[practiceId]

    modalOptions =
      doc: data
      template: Template.editGroupRoles
      title: "Edit Roles for " + practiceIdToName(practiceId)
      removeOnHide: true #optional. If this is true, modal will be removed from DOM upon hiding
      buttons:
        save:
          closeModalOnClick: true # if this is false, dialog doesnt close automatically on click
          class: "btn-success"
          label: "Save"

        removePractice:
          closeModalOnClick: false # if this is false, dialog doesnt close automatically on click
          class: "btn-default pull-left"
          label: "Remove User From Practice"
          id: "removePractice"

        cancel:
          class: "btn-default"
          label: "Cancel"

    rd = ReactiveModal.initDialog(modalOptions)
    rd.show()
    rd.buttons.save.on "click", (button) ->
      form = $(rd.modalTarget).find("#editGroupRoles")
      form = processForm(form)
      Meteor.call "updateRoles", Session.get("currentUserId"), form.roles, form.practiceId, (error, result) ->
        throwError error.reason  if error
        return

      return

    rd.buttons.removePractice.on "click", (button) ->
      #Inline Confirmation
      if not @confirmShown
      	$('#'+@id).text('Are you Sure?').addClass( 'btn-danger' )
      	this.confirmShown = true
      	return
      #manually close the Modal after confirmation
      rd.hide()

      form = $(rd.modalTarget).find("#editGroupRoles")
      form = processForm(form)

      Meteor.call "removeUserFromGroup", Session.get("currentUserId"), form.practiceId, (error, result) ->
        throwError error.reason  if error
        return

      return

    return

  "click .add-global-access": (e, t) ->
    Meteor.call "updateRoles", Session.get("currentUserId"), [], Roles.GLOBAL_GROUP, (error, result) ->
      throwError error.reason  if error
      return

    return

practiceIdToName = (practiceId) ->
  
  #return the practice name, or Global name, or the string "Restricted Practice (name hidden)" in case whoever is looking doesn't have access to the practice
  return "Global Access"  if practiceId is Roles.GLOBAL_GROUP
  practice = Practices.findOne(practiceId)
  return practice.name  if practice
  return "Restricted Practice (name hidden)"

Template.editGroupRoles.inheritsHelpersFrom("permissions")