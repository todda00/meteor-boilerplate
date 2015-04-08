root = exports ? this

root.setupPager = (pager) ->
  if typeof pager is 'number'
    pager =
      page: pager

  if typeof pager is 'string'
    pager =
      page: Number(pager)

  pager = {} if typeof pager isnt 'object'
  pager.page = pager.page ? 1
  pager.perPage = pager.perPage ? 25
  pager.skip = (pager.page - 1) * pager.perPage
  
  pager.page = Number(pager.page) if typeof pager.page isnt 'number'
  pager.perPage = Number(pager.perPage) if typeof pager.perPage isnt 'number'
  pager.sortOrder = Number(pager.sortOrder) if typeof pager.sortOrder isnt 'number'
  # pager.filters = pager.filters ? {}

  queryOptions = {}
  queryOptions.setter =
    skip: pager.skip
    limit: pager.perPage

  if pager.sortBy?
    pager.sortOrder = pager.sortOrder ? 1
    queryOptions.setter.sort = {}
    queryOptions.setter.sort[pager.sortBy] = pager.sortOrder

  queryOptions.filters = pager.filters || {}

  return queryOptions
