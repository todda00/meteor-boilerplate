Meteor.startup ->
  
  Factory.define 'examples', Examples, 
    name: ->
      Fake.sentence()
    description: ->
      Fake.paragraph()

  if Examples.find({}).count() is 0
    _(10).times (n) ->
      Factory.create('examples')
