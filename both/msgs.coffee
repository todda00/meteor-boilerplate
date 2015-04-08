root = exports ? this
# Client messaging system
# Types: 
# info
# success
# warning
# error

# Local (client-only) collection

root.Msgs = new (Meteor.Collection)(null)

root.throwError = (message) ->
  msg = undefined
  if typeof message == 'string'
    Msgs.insert
      message: message
      seen: false
      type: 'error'
  if typeof message == 'object'
    msg = if message.message != null then message.message else undefined
    msg = if message.reason != null then message.reason else undefined
    if msg != null
      return Msgs.insert(
        message: msg
        seen: false
        type: 'error')
  return

root.showMsg = (message, type) ->
  allowedTypes = undefined
  # Default to info if a bad type was given
  allowedTypes = [
    'info'
    'success'
    'warning'
    'error'
  ]
  if allowedTypes.indexOf(type) == -1
    type = 'info'
  Msgs.insert
    message: message
    seen: false
    type: type
  return

root.clearMsgs = ->
  Msgs.remove seen: true
  return

root.methodMsgs = (err, res) ->
  #We don't need any client messaging on the server
  return true if Meteor.isServer

  clearMsgs()
  if err
    throwError err.reason
    return
  
  if res? and res.message?
    showMsg(res.message, res.type)
    return

  if res? and typeof res is 'string'
    showMsg(res)
    return
