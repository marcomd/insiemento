// import Vue from 'vue'
// import VueRouter from 'vue-router'
import { createRouter, createWebHistory } from 'vue-router'
import store from './store/store'

//
// --- Please define components used in the router into pages folder ---
//

import Login from './pages/session/login'
import Test from './pages/session/test'
import SignUp from './pages/session/sign_up'
import SignedUp from './pages/session/signed_up'
import PasswordReset from './pages/session/password_reset'
import NewPassword from './pages/session/new_password'
import ConfirmationEmail from './pages/session/confirmation_email'
import ShowProfile from './pages/profile/show'
import EditProfile from './pages/profile/edit'
import NotFound from './pages/not_found'
import Homepage from './pages/homepage'
import Dashboard from './pages/dashboard'
import CourseEventIndex from './pages/course_events_index'
import CourseEventShow from './pages/course_event_show'
import ProductsIndex from './pages/products_index'
import ProductShow from './pages/product_show'
import OrderShow from './pages/order_show'
import Privacy from './pages/privacy'
import TermsAndConditions from './pages/terms_and_conditions'
import Cookie from './pages/cookie'

// all routes are private by default
const routes = [
  {
    path: '/',
    name: 'home',
    component: Homepage,
    meta: {
      public: true
    }
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
    path: '/terms_and_conditions',
    name: 'TermsAndConditions',
    component: TermsAndConditions,
    meta: {
      public: true,
      onlyWhenLoggedOut: true
    }
  },
  {
    path: '/privacy',
    name: 'Privacy',
    component: Privacy,
    meta: {
      public: true,
      onlyWhenLoggedOut: true
    }
  },
  {
    path: '/cookie',
    name: 'Cookie',
    component: Cookie,
    meta: {
      public: true,
      onlyWhenLoggedOut: true
    }
  },
  {
    path: '/dashboard',
    name: 'dashboard',
    component: Dashboard,
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
    path: '/courses',
    name: 'CourseEventIndex',
    component: CourseEventIndex
  },
  {
    path: '/course/:id',
    name: 'courseEventShow',
    component: CourseEventShow
  },
  {
    path: '/products',
    name: 'Products',
    component: ProductsIndex,
  },
  {
    path: '/products/:id',
    name: 'ProductShow',
    component: ProductShow,
  },
  {
    path: '/orders/:id',
    name: 'OrderShow',
    component: OrderShow,
  },
  {
    path: "/:catchAll(.*)",
    name: "NotFound",
    component: NotFound,
    meta: {
      public: true
    }
  }
]

const router = createRouter({
  // mode: 'history',
  history: createWebHistory('users'),
  //history: createWebHistory(import.meta.env.VITE_BASE_URL),
  // base: 'users',
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
