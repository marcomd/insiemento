<template>
  <v-navigation-drawer app right
    :value='sidebarOpened'
    @input='setSidebarStatus'
  >
    <div class='text-right d-block d-sm-block d-md-none'>
      <LocaleSelector/>
    </div>
    <v-list>
      <!--v-list-item exact :to='{name: "home"}' v-if='!isLoggedIn'>
        <v-list-item-action>
          <v-icon>mdi-home</v-icon>
        </v-list-item-action>
        <v-list-item-content>
          <v-list-item-title>{{ $t('sidebar.home') }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item-->
      <v-list-item :to='{name: "login"}' v-if='!isLoggedIn'>
        <v-list-item-action>
          <v-icon>mdi-account-arrow-right</v-icon>
        </v-list-item-action>
        <v-list-item-content>
          <v-list-item-title>{{ $t('sidebar.login') }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <v-list-item :to='{name: "signUp"}' v-if='!isLoggedIn'>
        <v-list-item-action>
          <v-icon>mdi-account-plus</v-icon>
        </v-list-item-action>
        <v-list-item-content>
          <v-list-item-title>{{ $t('sidebar.sign_up') }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <v-list-item :to='{name: "showProfile"}' v-if='isLoggedIn'>
        <v-list-item-action>
          <v-icon>mdi-account</v-icon>
        </v-list-item-action>
        <v-list-item-content>
          <v-list-item-title>{{ $t('sidebar.profile') }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <v-list-item :to='{name: "dashboard"}' v-if='isLoggedIn'>
        <v-list-item-action>
          <v-icon>mdi-view-dashboard</v-icon>
        </v-list-item-action>
        <v-list-item-content>
          <v-list-item-title>{{ $t('sidebar.dashboard') }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <v-list-item @click='logout' v-if='isLoggedIn'>
        <v-list-item-action>
          <v-icon>mdi-logout-variant</v-icon>
        </v-list-item-action>
        <v-list-item-content>
          <v-list-item-title>{{ $t('sidebar.logout') }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <v-list-item @click='askForSupport'>
        <v-list-item-action>
          <v-icon>mdi-help-circle-outline</v-icon>
        </v-list-item-action>
        <v-list-item-content>
          <v-list-item-title>{{ $t('sidebar.help') }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-list>
  </v-navigation-drawer>
</template>

<script>
  import { mapState, mapGetters, mapActions } from 'vuex'
  import LocaleSelector from './locale_selector'
  import { courseEventMixin } from '../../mixins/course_event_mixin'

  export default {
    mixins: [ courseEventMixin ],
    components: {
      LocaleSelector
    },
    computed: {
      ...mapState('layout', [
        'sidebarOpened'
      ]),
      ...mapState('application', [
        'current_organization'
      ]),
      ...mapGetters('session', [
        'isLoggedIn'
      ]),
      privateOrderSection() {
        return ['dashboard', 'orderShow', 'checkinGuests', 'checkinContract', 'checkinInvoice', 'checkinSummary'].includes(this.$route.name)
      },
      supportLink() {
        return this.privateOrderSection && !!this.support_email ? this.orderSupportLink : this.genericSupportLink
      },
      orderSupportLink() {
        return `mailto:${this.support_email}?subject=${this.$t('footer.support_email.subject_with_order', {code: this.order.code})}`
      },
      genericSupportLink() {
        // return 'https://www.italianway.house/contattaci'
        // return `mailto:${this.support_email}?subject=${this.$t('footer.support_email.subject')}`
        return `mailto:${this.current_organization.cs_email}?subject=${this.$t('footer.support_email.subject')}`
      }
    },
    methods: {
      ...mapActions({
        logout: 'session/logout',
        setSidebarStatus: 'layout/setSidebarStatus'
      }),
      ...mapGetters('profile', ['currentUser']),
      askForSupport() {
        console.log(`askForSupport`, this.supportLink)
        let redirectWindow = window.open(this.supportLink)
        redirectWindow.location
      }
    }
  }
</script>
