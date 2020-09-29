<template>
  <v-row v-if="hasCurrentUser && !isCurrentUserCompleted">
    <v-col>
      <v-alert
          type="info"
          colored-border
          color="primary lighten-2"
          elevation="2"
          border="left"
      >
        {{ $t('profile.hints.incomplete_profile') }}
        <v-btn
            text
            color="primary"
            :to='{name: "editProfile"}'
        >
          {{ $t('commons.next') }}
        </v-btn>
      </v-alert>
    </v-col>
  </v-row>
</template>

<script>
  // import { utilityMixin } from '../../mixins/utility_mixin'
  // import { productMixin } from '../../mixins/product_mixin'

  export default {
    // mixins: [ utilityMixin, productMixin ],
    props: {
      hasCurrentUser: {
        type: Boolean,
        required: true
      },
      isCurrentUserCompleted: {
        type: Boolean,
        required: true
      },
    },
    computed: {
    }
  }
</script>

<style lang="scss" scoped>

</style>
