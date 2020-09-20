<template>
  <v-container class="justify-center">

    <CookiePolicyContent :organization-name="currentOrganizationName" />

    <AcceptOrAway />

  </v-container>
</template>

<script>
  import CookiePolicyContent from '../components/homepage/cookie_policy_content'
  import AcceptOrAway from '../components/homepage/accept_or_away'

  import { homepageContentMixin } from '../mixins/homepage_content_mixin'

  export default {
    mixins: [
      homepageContentMixin,
    ],

    components: {
      CookiePolicyContent,
      AcceptOrAway,
    },
  }
</script>

<style lang="scss" scoped>
</style>
