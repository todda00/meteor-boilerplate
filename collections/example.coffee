root = exports ? this

root.Examples = new (Mongo.Collection)('examples')

# Examples.before.insert (userId, doc) ->

# Examples.before.update (userId, doc, fieldNames, modifier) ->

# Examples.before.remove (userId, doc) ->

Schemas = Schemas || {}
Schemas.Examples = new SimpleSchema
  name:
    type: String
    label: 'Example Name'
  description:
    type: String
    label: 'Description'

Examples.attachSchema Schemas.Examples

Examples.friendlySlugs(
  slugFrom: 'name'
)