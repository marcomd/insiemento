<template>
  <v-snackbar
          v-model="snackbar.show"
          :timeout="snackbar.timeout"
          :color="snackbar.color"
          :multi-line="snackbar.multi_line"
  >
    {{ snackbar.text }}
    <v-btn
            text
            @click="snackbar.show = false"
    >
      {{ $t('commons.close') }}
    </v-btn>
  </v-snackbar>
</template>

<script>
  import { mapState } from 'vuex'

  export default {
    computed: {
      ...mapState('layout', ['snackbar']),
    },
  }
</script>

<style lang='scss' scoped>
</style>
