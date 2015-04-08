Template.registerHelper 'siteTitle', (string) ->
  SEO.settings.title
Template.registerHelper 'summarize', (string) ->
  cleanString = _(string).stripTags()
  _(cleanString).truncate 140

Template.registerHelper 'moment', (date, format) ->
  date = moment(date)
  return date.format format
Template.registerHelper 'objToArray', (obj) ->
  result = []
  for key of obj
    result.push
      name: key
      value: obj[key]
  result
Template.registerHelper 'log', (item) ->
  console.log item
  return
Template.registerHelper 'equals', (item1, item2) ->
  item1 == item2

Template.registerHelper 'currentYear', ->
  return new Date().getFullYear()

Template.registerHelper 'cursorHasItems', (cursor) ->
  return cursor.count() > 0
