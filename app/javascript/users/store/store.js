import Vue from 'vue'
import Vuex from 'vuex'
import * as application from './modules/application'
import * as session from './modules/session'
import * as layout from './modules/layout'
import * as profile from './modules/profile'
import * as course_event from './modules/course_event'
import * as product from './modules/product'
import * as order from './modules/order'

Vue.use(Vuex)

const debug = process.env.NODE_ENV !== 'production'

export default new Vuex.Store({
  modules: {
    application,
    session,
    layout,
    profile,
    course_event,
    product,
    order,
  },
  state: {},
  strict: debug,
})
