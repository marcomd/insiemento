import Vue from 'vue'
import Vuetify from 'vuetify'

import 'vuetify/dist/vuetify.min.css'
import '@mdi/font/css/materialdesignicons.css'

Vue.use(Vuetify)

// Alcuni colori sono parametri forniti dal backend, impostati nel primo componente index.vue
export default new Vuetify({
  icons: {
    iconfont: 'mdi'
  },
  // theme: {
  //   light: true,
  //   themes: {
  //     light: {
  //       primary: '#e3696a',
  //       secondary: '#b0bec5',
  //       accent: '#e3696a',
  //       error: '#b71c1c',
  //       info: '#e3696a',
  //     },
  //   },
  // }
})