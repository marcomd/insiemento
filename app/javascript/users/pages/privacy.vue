<template>
  <v-container class="justify-center">

    <PrivacyPolicyContent :organization-name="currentOrganizationName" :is-current-organization-present="isCurrentOrganizationPresent" />

    <AcceptOrAway />

  </v-container>
</template>

<script>
  import PrivacyPolicyContent from '../components/homepage/privacy_policy_content'
  import AcceptOrAway from '../components/homepage/accept_or_away'

  import { homepageContentMixin } from '../mixins/homepage_content_mixin'

  export default {
    mixins: [
      homepageContentMixin,
    ],

    components: {
      PrivacyPolicyContent,
      AcceptOrAway,
    },
  }
</script>

<style lang="scss">
</style>
