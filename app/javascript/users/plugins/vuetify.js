// import Vue from 'vue'
// import Vuetify from 'vuetify'
//
// import 'vuetify/dist/vuetify.min.css'
import '@mdi/font/css/materialdesignicons.css'

// Vuetify
import 'vuetify/styles'
import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'

const vuetify = createVuetify({
  components,
  directives,
  // icons: {
  //   iconfont: 'mdi'
  // },
  // theme: {
  //   light: true,
  //   themes: {
  //     light: {
  //       primary: '#e03f4b',
  //       secondary: '#666666',
  //     },
  //   },
  // }
})

// Alcuni colori sono parametri forniti dal backend, impostati nel primo componente index.vue
// export default new Vuetify({
//   icons: {
//     iconfont: 'mdi'
//   },
//   theme: {
//     light: true,
//     themes: {
//       light: {
//         primary: '#e03f4b',
//         secondary: '#666666',
//       },
//     },
//   }
// })

export default vuetify