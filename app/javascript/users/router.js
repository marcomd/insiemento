import Vue from 'vue'
import VueRouter from 'vue-router'
import store from './store/store'
import Login from './components/session/login'
import SignUp from './components/session/sign_up'
import SignedUp from './components/session/signed_up'
import PasswordReset from './components/session/password_reset'
import NewPassword from './components/session/new_password'
import ConfirmationEmail from './components/session/confirmation_email'
import ShowProfile from './components/profile/show'
import EditProfile from './components/profile/edit'
import NotFound from './pages/not_found'
import Home from './pages/home'
import Dashboard from './pages/dashboard'

Vue.use(VueRouter)

// all routes are private by default
const routes = [
  {
    path: '/',
    name: 'home',
    component: Home,
    meta: {
      public: true
    }
  },
  {
    path: '/dashboard',
    name: 'dashboard',
    component: Dashboard,
  },
  {
    path: '/login',
    name: 'login',
    component: Login,
    meta: {
      public: true,
      onlyWhenLoggedOut: true
    }
  },
  {
    path: '/sign-up',
    name: 'signUp',
    component: SignUp,
    meta: {
      public: true,
      onlyWhenLoggedOut: true
    }
  },
  {
    path: '/signed-up',
    name: 'signedUp',
    component: SignedUp,
    meta: {
      public: true,
      onlyWhenLoggedOut: true
    }
  },
  {
    path: '/password-reset',
    name: 'passwordReset',
    component: PasswordReset,
    meta: {
      public: true,
      onlyWhenLoggedOut: true
    }
  },
  {
    path: '/new-password',
    name: 'newPassword',
    component: NewPassword,
    meta: {
      public: true,
      onlyWhenLoggedOut: true
    }
  },
  {
    path: '/confirmation-email',
    name: 'confirmationEmail',
    component: ConfirmationEmail,
    meta: {
      public: true,
      onlyWhenLoggedOut: true
    }
  },
  {
    path: '/profile',
    name: 'showProfile',
    component: ShowProfile
  },
  {
    path: '/edit-profile',
    name: 'editProfile',
    component: EditProfile
  },
  {
    path: '*',
    component: NotFound,
    meta: {
      public: true
    }
  }
]

const router = new VueRouter({
  mode: 'history',
  base: 'users',
  routes: routes,
  scrollBehavior(to, from, savedPosition) {
    return { x: 0, y: 0 }
  }
})

router.beforeEach((to, from, next) => {
  if (!isPublic(to) && !isLoggedIn()) {
    store.dispatch('layout/replaceAlert', {
        type: 'warning',
        key: 'unauthorized'
    })

    return next({
      path: '/login',
      query: {
        redirectTo: to.fullPath // Store the full path to redirect the user to after login
      }
    })
  }

  // Do not allow user to visit login page or register page if they are logged in
  if (isLoggedIn() && onlyWhenLoggedOut(to)) return next('/')

  next()
})

router.beforeResolve((to, from, next) => {
  if (!!to.query.redirectTo) {
    // coming from a private page, let's redirect to login and keep alert
  } else {
    store.dispatch('layout/clearAlerts')
  }

  next()
})

const isPublic = function (to) {
  return to.matched.some(record => record.meta.public)
}

const onlyWhenLoggedOut = function (to) {
  return to.matched.some(record => record.meta.onlyWhenLoggedOut)
}

const isLoggedIn = function () {
  return store.getters['session/isLoggedIn']
}

export default router
