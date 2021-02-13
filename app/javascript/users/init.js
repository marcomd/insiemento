import Vue from 'vue'

import App from './components/index'
import store from './store/store'
import router from './router'

import dayjs from 'dayjs'

import VueResource from 'vue-resource'
import VueI18n from 'vue-i18n'
import Vuelidate from 'vuelidate'

import vuetify from './plugins/vuetify'
import './plugins'

// import * as VueGoogleMaps from 'vue2-google-maps'

Vue.use(VueResource)
Vue.use(VueI18n)
Vue.use(Vuelidate)

const init = function() {
  let el = document.getElementById('users-vue-wrapper')
  if (el !== null) {
    let id = '#' + el.getAttribute('id')
    let props = JSON.parse(el.getAttribute('data-props'))
      
    // Vue.use(VueGoogleMaps, {
    //   load: {
    //     key: 'AIzaSyAtHxouX3MKalgzR2gA7QP9CnONNDBBej8',
    //     v: '3.26',
    //     libraries: 'places', // This is required if you use the Autocomplete plugin
    //     // OR: libraries: 'places,drawing'
    //     // OR: libraries: 'places,drawing,visualization'
    //     // (as you require)
    //
    //     //// If you want to set the version, you can do so:
    //     // v: '3.26',
    //   },
    //
    //   //// If you intend to programmatically custom event listener code
    //   //// (e.g. `this.$refs.gmap.$on('zoom_changed', someFunc)`)
    //   //// instead of going through Vue templates (e.g. `<GmapMap @zoom_changed="someFunc">`)
    //   //// you might need to turn this on.
    //   // autobindAllEvents: false,
    //
    //   //// If you want to manually install components, e.g.
    //   //// import {GmapMarker} from 'vue2-google-maps/src/components/marker'
    //   //// Vue.component('GmapMarker', GmapMarker)
    //   //// then disable the following:
    //   // installComponents: true,
    // })

    let locale = localStorage.getItem('userLocale') || el.getAttribute('data-locale')
    dayjs.locale('it') // force IT locale to have a consistent date format for all locales
    Vue.http.headers.common['Accept-Language'] = locale

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
