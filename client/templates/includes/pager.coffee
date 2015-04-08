#Clear the pager session on login and logout
Tracker.autorun ->
  trackMe = Meteor.userId()
  SessionAmplify.set('pager',{})

Template.pager.rendered = ->
  #If the route doesn't match the pager defined route, delete the pager so it defaults
  pager = SessionAmplify.get('pager')
  if pager.path isnt Router.current().route.getName()
    SessionAmplify.set('pager',{})

Template.pager.created = ->
  pager = SessionAmplify.get('pager')
  pager.total = Counts.get(@data.count)
  return false if !pager? or !pager.total?
  pager.perPage = pager.perPage ? 25
  pager.page = Number(pager.page) if typeof pager.page isnt 'number'
  pager.numPages = Math.ceil(pager.total / pager.perPage)
  # pager.filters = pager.filters ? {}
  pager = false if typeof pager.numPages isnt 'number'
  pager = false if !(pager.numPages > 1)

  @pagerReativeVar = new ReactiveVar
  @pagerReativeVar.set(pager)

Template.pager.helpers 
  pager: ->
    return false if !Template.instance().pagerReativeVar?
    pager = Template.instance().pagerReativeVar.get()
    pager.total = Counts.get(@count)
    pager.numPages = Math.ceil(pager.total / pager.perPage)
    pager = false if !(pager.numPages > 1)
    return false if !pager?
    return pager

  pages: ->
    pager = Template.instance().pagerReativeVar.get()
    pages = []
    pages.push(pager.page - 2) if (pager.page - 2) > 0
    pages.push(pager.page - 1) if (pager.page - 1) > 0
    pages.push(pager.page)
    pages.push(pager.page + 1) if (pager.page + 1) <= pager.numPages
    pages.push(pager.page + 2) if (pager.page + 2) <= pager.numPages
    return pages

  previousPage: ->
    pager = Template.instance().pagerReativeVar.get()
    return (pager.page - 1) if (pager.page - 1) > 0
    return false

  nextPage: ->
    pager = Template.instance().pagerReativeVar.get()
    return (pager.page + 1) if !((pager.page + 1) > pager.numPages)
    return false

  active: (page) ->
    pager = Template.instance().pagerReativeVar.get()
    return 'active' if page is pager.page

Template.sortArrow.helpers
  arrowDirection: (sortBy) ->
    pager = SessionAmplify.get('pager')
    return false if pager.sortBy != sortBy
    if pager.sortOrder is 1
      return 'up'
    if pager.sortOrder is -1
      return 'down'


Template.registerHelper 'pagerInstance', ->
  return SessionAmplify.get('pager')