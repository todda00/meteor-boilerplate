root = exports ? this

Router.map ->
  @route "home",
    path: "/"

  @route "user",
    path: "/users/:_id"
    waitOn: ->
      [
        @subscribe("user", @params._id)
      ]
    data: ->
      Meteor.users.findOne _id: @params._id

    onAfterAction: ->
      if @data()?
        SEO.set title: 'Edit ' + @data().profile.firstName + " " + @data().profile.lastName + " | " + SEO.settings.title
      return


  @route "users",
    path: "/users"
    waitOn: ->
      @subscribe "users"

    data: ->
      setter = {}
      Meteor.users.find({})

    onAfterAction: ->
      SEO.set title: "User List | " + SEO.settings.title
      return  

  @route "examples",
    path: "/examples"
    waitOn: ->
      @subscribe "examples"

    data: ->
      Examples.find({})

    onAfterAction: ->
      SEO.set title: "Example List | " + SEO.settings.title
      return

  @route "example",
    path: "/example/:slug"
    waitOn: ->
      @subscribe("example", @params.slug)
    data: ->
      Examples.findOne slug: @params.slug

    onAfterAction: ->
      if @data()?
        SEO.set title: @data().name + " | " + SEO.settings.title
      return

  @route "notFound",
    path: "*"
    where: "server"
    action: ->
      @response.statusCode = 404
      @response.end Handlebars.templates["404"]()
      return
