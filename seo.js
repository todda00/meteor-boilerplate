Meteor.startup(function() {
  if(Meteor.isClient) {
    SEO.config({
      title: 'Boilerplate App',
      meta: {
        'description': 'A project by Todd'
      },
      og: {
        'image': Meteor.absoluteUrl('share-image.png')
      },
      ignore: {
        meta: ['fragment', 'viewport', 'msapplication-TileColor', 'msapplication-TileImage', 'msapplication-config'],
        link: ['stylesheet', 'apple-touch-icon', 'rel', 'shortcut icon', 'icon']
      }
    });
  }
});
