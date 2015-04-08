AccountsTemplates.configure({
     # Behaviour
    confirmPassword: true,
    enablePasswordChange: true,
    forbidClientAccountCreation: false,
    overrideLoginErrors: false,
    sendVerificationEmail: false,

    # Appearance
    showAddRemoveServices: false,
    showForgotPasswordLink: true,
    showLabels: false,
    showPlaceholders: true,

    # Client-side Validation
    continuousValidation: false,
    negativeFeedback: false,
    negativeValidation: true,
    positiveValidation: true,
    positiveFeedback: true,
    showValidating: true,

    # Privacy Policy and Terms of Use
    # privacyUrl: 'privacy',
    # termsUrl: 'terms-of-use',

    # Redirects
    homeRoutePath: '/',
    redirectTimeout: 2000,

    # Hooks
    # onLogoutHook: myLogoutFunc,
    # onSubmitHook: mySubmitFunc,

    # Texts
    texts: {
      button: {
          signUp: "Register Now!"
      },
      signInLink_link: 'log in'
      socialSignUp: "Register",
      title: {
          forgotPwd: "Recover Your Password"
          signIn: "Log In"
      },
    },
});


AccountsTemplates.configureRoute 'signIn',
  path:'/login'

AccountsTemplates.configureRoute 'signUp',
  path:'/register'

AccountsTemplates.configureRoute 'forgotPwd'
AccountsTemplates.configureRoute 'resetPwd'
AccountsTemplates.configureRoute 'changePwd'
AccountsTemplates.configureRoute 'enrollAccount'

Router.map ->
  @route '/logout',
    onBeforeAction: ->
      Meteor.logout()
      @redirect('/')

Router.plugin('ensureSignedIn', {
    except: ['atSignIn', 'atForgotPwd', 'atResetPwd', 'atEnrollAccount', 'atSignUp']
});