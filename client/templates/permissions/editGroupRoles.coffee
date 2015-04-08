Template.editGroupRoles.helpers
	globalAccess: ->
		return true if @name is Roles.GLOBAL_GROUP

