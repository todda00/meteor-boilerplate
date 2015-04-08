Template.home.created = () ->
  instance = Template.instance()
  @showAddAdmin = new ReactiveVar
  Meteor.call 'countUsers', (error,result) ->
    throwError error.reason if error
    instance.showAddAdmin.set(result is 1)  

Template.home.helpers
  showAddAdmin: () ->
    return Template.instance().showAddAdmin.get()

Template.home.events
  'click #addAdmin': () ->
    Meteor.call 'addSelfAdmin', (error, result) ->
      throwError error.reason if error