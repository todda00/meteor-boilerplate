root = exports ? this

Router.configure
  layoutTemplate: "mainLayout"
  loadingTemplate: "loading"
  yieldTemplates:
    header:
      to: "header"

    footer:
      to: "footer"

  onAfterAction: ->
    #Scroll to the top for a new page, or stay where they are for other form submit items (autoform autosave)
    if !window? or !window.scrollY?
      $(document).scrollTop 0
    return

Router.onBeforeAction "loading"
Router.onBeforeAction ->
  clearMsgs()
  #Collapse the navbar if needed
  $('.navbar-collapse').removeClass('in')
  
  @next()
  return
