import Vue from 'vue'
import Vuex from 'vuex'
import * as application from './modules/application'
import * as session from './modules/session'
import * as layout from './modules/layout'
import * as profile from './modules/profile'

Vue.use(Vuex)

const debug = process.env.NODE_ENV !== 'production'

export default new Vuex.Store({
  modules: {
    application,
    session,
    layout,
    profile,
  },
  state: {},
  strict: debug,
})
