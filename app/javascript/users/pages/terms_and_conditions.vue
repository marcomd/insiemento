<template>
  <v-container class="justify-center">

    <TermsAndConditionsContent :organization-name="currentOrganizationName"
                               :organization-site-url="current_organization.site_url" :organization-email="current_organization.email || 'privacy@insiemento.com'" />

    <AcceptOrAway />

  </v-container>
</template>

<script>
  import TermsAndConditionsContent from '../components/homepage/terms_and_conditions_content'
  import AcceptOrAway from '../components/homepage/accept_or_away'

  import { homepageContentMixin } from '../mixins/homepage_content_mixin'

  export default {
    mixins: [
      homepageContentMixin,
    ],

    components: {
      TermsAndConditionsContent,
      AcceptOrAway,
    },
  }
</script>

<style lang="scss" scoped>
</style>
