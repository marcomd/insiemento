<template>
  <v-row v-if="isLoggedIn">
    <v-col class="text-center">
      <slot></slot>
    </v-col>
  </v-row>
  <v-row v-else>
    <v-col class="text-center">
      <v-btn x-large
             color=''
             class='mr-2 mb-2'
             :to='{name: "signUp"}'
      >
        {{ $t('sidebar.sign_up') }}
      </v-btn>
      <v-btn x-large
             color='primary'
             class='mr-2 mb-2'
             :to='{name: "login"}'
      >
        {{ $t('session.login_action') }}
      </v-btn>
    </v-col>
  </v-row>
</template>

<script>
  import { mapGetters } from 'vuex'

  export default {
    name: "authentication_buttons",
    props: {
      redirect_to: String
    },
    computed: {
      ...mapGetters('session', [
        'isLoggedIn'
      ])
    }
  }
</script>

<style scoped>

</style>
