<template>
  <v-app class='user-app'>
    <Sidebar/>
    <Header/>
    <v-main>
      <Alerts/>
      <Snackbar/>
      <router-view/>
    </v-main>
    <Footer/>
  </v-app>
</template>

<script>
  // import Vue from 'vue'
  import { mapGetters } from 'vuex'
  import Header from './layout/header'
  import Sidebar from './layout/sidebar'
  import Footer from './layout/footer'
  import Alerts from './layout/alerts'
  import Snackbar from './layout/snackbar'
  import axios from 'axios'

  export default {
    components: {
      Header,
      Sidebar,
      Footer,
      Alerts,
      Snackbar,
    },
    props: {
      urls: Object,
      options: Object,
      current_organization: Object,
    },
    computed: {
      ...mapGetters('session', [
        'isLoggedIn'
      ])
    },
    created() {
      console.log('index.vue urls', this.urls)
      if (this.current_organization.theme) {
        if (this.current_organization.theme.dark_mode) {
          this.$vuetify.theme.dark = true
          if (this.current_organization.theme.primary_color)    this.$vuetify.theme.themes.dark.primary = this.current_organization.theme.primary_color
          if (this.current_organization.theme.secondary_color)  this.$vuetify.theme.themes.dark.secondary = this.current_organization.theme.secondary_color
          if (this.current_organization.theme.accent_color)     this.$vuetify.theme.themes.dark.accent = this.current_organization.theme.accent_color
          if (this.current_organization.theme.info_color)       this.$vuetify.theme.themes.dark.info = this.current_organization.theme.info_color
          if (this.current_organization.theme.success_color)    this.$vuetify.theme.themes.dark.success = this.current_organization.theme.success_color
          if (this.current_organization.theme.error_color)      this.$vuetify.theme.themes.dark.error = this.current_organization.theme.error_color
          if (this.current_organization.theme.warning_color)    this.$vuetify.theme.themes.dark.warning = this.current_organization.theme.warning_color
        } else {
          this.$vuetify.theme.light = true
          if (this.current_organization.theme.primary_color)    this.$vuetify.theme.themes.light.primary = this.current_organization.theme.primary_color
          if (this.current_organization.theme.secondary_color)  this.$vuetify.theme.themes.light.secondary = this.current_organization.theme.secondary_color
          if (this.current_organization.theme.accent_color)     this.$vuetify.theme.themes.light.accent = this.current_organization.theme.accent_color
          if (this.current_organization.theme.info_color)       this.$vuetify.theme.themes.light.info = this.current_organization.theme.info_color
          if (this.current_organization.theme.success_color)    this.$vuetify.theme.themes.light.success = this.current_organization.theme.success_color
          if (this.current_organization.theme.error_color)      this.$vuetify.theme.themes.light.error = this.current_organization.theme.error_color
          if (this.current_organization.theme.warning_color)    this.$vuetify.theme.themes.light.warning = this.current_organization.theme.warning_color
        }
      }
      // axios.interceptors.request.use(request => {
      //   // Do something before request is sent
      //   console.log('Intercepted request', request)
      //   return request;
      // }, function (error) {
      //   // Do something with request error
      //   return Promise.reject(error);
      // });

      axios.interceptors.response.use(response => {
        //console.log('Intercepted response', response)
        if (response.data.skipInterceptors) return {}

        // Perchè un clear globale? Non consente di mostrare i messaggi impostati prima del routing
        // this.$store.dispatch('layout/clearAlerts')
        switch (response.status) {
          case 401:
            this.$store.dispatch('layout/clearAlerts')
            this.$store.dispatch('session/logout', true)
            break
          case 500:
            console.log('Catched a 500!', response.body)
            this.$store.dispatch('layout/replaceAlert', {
              type: 'error',
              key: 'error_500'
            })
            break
        }
        return response
      }, error => {
        return Promise.reject(error)
      })

      this.$store.dispatch('application/loadInitialProps', {
        urls: this.urls,
        options: this.options,
        current_organization: this.current_organization,
      })

      if (this.isLoggedIn) {
        axios.defaults.headers.common['X-Auth-Token'] = 'Bearer ' + this.$store.state.session.authToken
        this.$store.dispatch('profile/fetchUser')
      }
    }
  }
</script>

<style lang="scss">
  @import url('https://fonts.googleapis.com/css?family=Open+Sans&display=swap');
  $body-font-family: 'Open Sans', sans-serif;

  .v-application {
    font-family: $body-font-family !important;
    div.title, h1.title, h2.title, h3.title, h4.title, h5.title, h6.title,
    div.headline, h1.headline, h2.headline, h3.headline, h4.headline, h5.headline, h6.headline {
      font-family: $body-font-family !important;
    }
  }

  h1, h2, h3, h4, h5, h6 {
    font-family: $body-font-family !important;
    &.subtitle {
      font-weight: 400;
      text-transform: uppercase;
      color: #555555;
    }
  }

  // background color moved to have a better styled checkin bottom navigation
  /*.user-app.theme--light.v-application {
    background-color: #ffffff;
  }
  .v-content__wrap {
    background-color: #fafafa;
  }*/
  .v-input {
    position: relative;
  }
  .v-input__append-outer {
    position: absolute;
    top: 5px;
    right: -5px;
    margin: 0 !important;
    .v-input__icon.v-input__icon--append-outer {
      width: auto;
      min-width: auto;
      height: auto;
      flex: none;
      .v-icon {
        font-size: 10px;
        &.mdi-asterisk {
          color: #ff5252 !important;
        }
      }
    }
  }
</style>
