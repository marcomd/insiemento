// import Vue from 'vue'
// import './plugins'


// import * as VueGoogleMaps from 'vue2-google-maps'
import ActionCableVue from 'actioncable-vue'
import axios from "axios"

const init = function() {
  import { createApp } from 'vue'
  const app = createApp({})

  import App from './components/index'
  import store from './store/store'
  import router from './router'

  import moment from 'moment'

  import VueI18n from 'vue-i18n'
  import Vuelidate from 'vuelidate'

  import vuetify from './plugins/vuetify'

  import LoadHomepageComponents from './plugins/load_homepage_components'
  LoadHomepageComponents(app)

  app.use(VueI18n)
  app.use(Vuelidate)

  let el = document.getElementById('users-vue-wrapper')
  if (el !== null) {
    let id = '#' + el.getAttribute('id')
    let props = JSON.parse(el.getAttribute('data-props'))

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

    let i18n = new VueI18n({
      locale: locale,
      messages: JSON.parse(el.getAttribute('data-i18n'))
    })

    window.uiApp = new Vue({
      i18n,
      vuetify,
      store,
      router,
      el: id,
      render: h => h(App, {
        props
      })
    })
  }
}

export default {
  init: init
}
