<template>
  <v-app-bar app
             :dark="useDark"
             :color="organizationBackgroundColor"
             elevation='1'>
    <v-toolbar-title>
      <router-link :to='{name: "dashboard"}' tag='button'>
        <img
          v-if="organizationLogo"
          :src='organizationLogo'
          height='45'
          class='logo'
        />
        
        <v-icon v-else large color="primary">mdi-domain</v-icon>
      </router-link>
    </v-toolbar-title>
    <v-spacer/>
    <v-toolbar-items class='mr-2 d-none d-md-flex'>
      <v-btn
        :to='{name: "showProfile"}'
        v-if='isLoggedIn'
        text
      >
        <v-icon left>mdi-account-outline</v-icon>
        {{ fullName }}
      </v-btn>
      <v-btn
        :to='{name: "login"}'
        v-if='!isLoggedIn'
        text
      >
        {{ $t('sidebar.login') }}
      </v-btn>
      <LocaleSelector/>
    </v-toolbar-items>
    <v-app-bar-nav-icon @click.stop='toggleSidebar'/>
  </v-app-bar>
</template>

<script>
  import { mapState, mapGetters } from 'vuex'
  import LocaleSelector from './locale_selector'

  export default {
    name: 'Header',
    components: {
      LocaleSelector
    },
    computed: {
      ...mapGetters('session', [
        'isLoggedIn'
      ]),
      ...mapGetters('profile', [
        'fullName'
      ]),
      ...mapState('application', ['current_organization']),
      organizationLogo() {
        // if (this.current_organization.logo) console.log('ATTENZIONE: caricare il logo per la compagnia ', this.current_organization.id)
        return this.current_organization.logo || '../../../../../../app/assets/images/logo_50.png' //
      },
      organizationBackgroundColor() {
        // if (this.current_organization.logo) console.log('ATTENZIONE: caricare il logo per la compagnia ', this.current_organization.id)
        return this.current_organization.theme.header_background_color || 'white' //|| '../../../../../../app/assets/images/img-logo.svg'
      },
      useDark() {
        // return ["white", "#fff", "#ffffff"].includes(this.current_organization.theme.color)
        return this.current_organization.theme.header_dark
      },
    },
    methods: {
      toggleSidebar: function() {
        this.$store.dispatch('layout/toggle_sidebar')
      }
    }
  }
</script>

<style lang='scss'>
  .logo {
    margin-top: 5px;
  }
</style>
