<template>
  <v-footer
      color="primary py-1 white--text"
      padless
      v-if="$vuetify.breakpoint.mdAndUp"
  >
    <v-row
        justify="center"
        no-gutters
    >
      <v-col
          class="text-center"
          cols="12"
      >
        {{ new Date().getFullYear() }} — {{ !!current_organization.name  ? 'Powered by' : 'Created by Marco Mastrodonato' }}  <v-btn text href="https://www.insiemento.com" target="_blank">Insiemento</v-btn>
      </v-col>
    </v-row>
  </v-footer>
</template>

<script>
  import { mapState } from 'vuex'

  export default {
    computed: {
      ...mapState('application', ['current_organization']),
    }
  }
</script>

<style lang="scss">
</style>
