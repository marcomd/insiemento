<template>
  <v-row v-if="hasOrganizationNews">
    <v-col>
      <v-alert
          v-for="(item, index) in organizationNews"
          :key="index"
          :color="item.color"
          :icon="item.icon"
          :dark="item.dark_style"
          :text="!item.dark_style"
          dismissible
      >
        <h4>{{ item.title }}</h4>
        <v-divider />
        <div>{{ item.body }}</div>
      </v-alert>
    </v-col>
  </v-row>
</template>

<script>
  import { mapState } from 'vuex'
  // import { utilityMixin } from '../../mixins/utility_mixin'
  import { newsMixin } from '../../mixins/news_mixin'

  export default {
    mixins: [ newsMixin ],

    computed: {
      ...mapState('application', ['current_organization']),
      organizationNews() { return this.organizationPrivateNews }
    },
  }
</script>

<style lang="scss" scoped>

</style>
