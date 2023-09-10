import { createApp } from 'vue'

import App from './components/index'
import store from './store/store'
import router from './router'

import moment from 'moment'

// import Vuelidate from 'vuelidate'
import { createI18n } from 'vue-i18n'

import vuetify from './plugins/vuetify'

import LoadHomepageComponents from './plugins/load_homepage_components'

import ActionCableVue from 'actioncable-vue'
import axios from "axios"

const init = function() {
  let el = document.getElementById('users-vue-wrapper')
  if (el !== null) {
    let id = '#' + el.getAttribute('id')
    let props = JSON.parse(el.getAttribute('data-props'))

    const app = createApp(App, { ...props })

    if (props?.options?.websocketUrl) {
      app.use(ActionCableVue, {
        debug: true,
        debugLevel: 'error',
        connectionUrl: props.options.websocketUrl, // or function which returns a string with your JWT appended to your server URL as a query parameter
        connectImmediately: true,
      })
    } else {
      console.error("Please set props -> options -> websocketUrl")
    }

    let locale = localStorage.getItem('userLocale') || el.getAttribute('data-locale') || 'it'
    axios.defaults.headers.common['Accept-Language'] = locale
    moment.locale(locale)

    const i18n = createI18n({
      locale: locale,
      messages: JSON.parse(el.getAttribute('data-i18n'))
    })

    LoadHomepageComponents(app)
    // app.use(Vuelidate)

    app.use(i18n)
        // .use(Vuelidate)
        .use(vuetify)
        .use(store)
        .use(router)
        .mount(id)

    // window.uiApp = new Vue({
    //   i18n,
    //   vuetify,
    //   store,
    //   router,
    //   el: id,
    //   render: h => h(App, {
    //     props
    //   })
    // })
  }
}

export default {
  init: init
}
