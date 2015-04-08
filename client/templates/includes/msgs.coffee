Template.msgs.helpers msgs: ->
  Msgs.find()

Template.msg.rendered = ->
  msg = @data
  Meteor.defer ->
    Msgs.update msg._id,
      $set:
        seen: true

    return

  return

Template.msg.helpers
  msgClass: ->
    return "danger"  if @type is "error"
    @type

  msgIcon: ->
    iconMap =
      info: "fa-info-circle"
      success: "fa-check-circle-o"
      warning: "fa-exclamation-triangle"
      error: "fa-exclamation-circle"

    iconMap[@type]