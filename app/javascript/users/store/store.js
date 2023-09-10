import { createStore } from 'vuex'

import * as application from './modules/application'
import * as session from './modules/session'
import * as layout from './modules/layout'
import * as profile from './modules/profile'
import * as course_event from './modules/course_event'
import * as product from './modules/product'
import * as subscription from './modules/subscription'
import * as order from './modules/order'

const debug = process.env.NODE_ENV !== 'production'

const store = createStore({
  modules: {
    application,
    session,
    layout,
    profile,
    course_event,
    product,
    subscription,
    order,
  },
  state: {},
  strict: debug,
})

// export store to use in init.js
export default store