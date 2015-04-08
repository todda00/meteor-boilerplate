Accounts.emailTemplates.siteName = 'The Boilerplate'
Accounts.emailTemplates.from = 'The Boilerplate <boilerplate@boilerplate.com>'

Accounts.emailTemplates.enrollAccount.subject = (user) ->
  'Welcome to the Boilerplate ' + user.profile.firstName + ' ' + user.profile.lastName + '!'

Accounts.emailTemplates.enrollAccount.text = (user, url) ->
  'An account has been created for you at the Boilerplate!\n\n' + 'We already setup your name and email, you just need to choose a password. Follow the link below to get setup.\n\n' + url