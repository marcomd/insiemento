<template>
  <section id="hero">
    <v-img
      :min-height="minHeight"
      :src="require('../../../assets/images/home-hero.jpg')"
      class="white--text"
      gradient="to right, rgba(5, 11, 31, .8), rgba(5, 11, 31, .8)"
    >
      <v-container class="fill-height px-4 py-12">
        <v-responsive
          class="d-flex align-center"
          height="100%"
          max-width="800"
          width="100%"
        >
          <base-heading :title="organizationTitle" />

          <base-body :html="organizationDescription" />

          <div
            :class="$vuetify.breakpoint.smAndDown ? 'flex-column align-start' : 'align-center'"
            class="d-flex flex-wrap"
            v-if="organizationEmail"
          >
            <base-btn
                :block="$vuetify.breakpoint.smAndDown"
                :href="`mailto:${organizationEmail}?subject=Informazioni%20servizio%20palestre`"
                large
                target="_blank"
            >
              Contattaci
            </base-btn>
          </div>

          <br>
          <base-heading :title="organizationCustomerTitle" />
          <base-body>{{ organizationCustomerDescription }}</base-body>
          <div v-if="isCurrentOrganizationPresent">
            <base-btn
                :block="$vuetify.breakpoint.smAndDown"
                large
                :to="{name: 'signUp'}"
            >
              {{ $t('sidebar.sign_up') }}
            </base-btn>

            <span class="font-weight-bold mx-4 my-4">o</span>

            <base-btn
                :block="$vuetify.breakpoint.smAndDown"
                class="pa-1"
                outlined
                :to="{name: 'login'}"
            >
              {{ $t('sidebar.login') }}
            </base-btn>
          </div>
        </v-responsive>
      </v-container>
    </v-img>
  </section>
</template>

<script>
  import { homepageContentMixin } from '../../../mixins/homepage_content_mixin'

  export default {
    name: 'SectionHero',

    provide: {
      theme: { isDark: true },
    },

    mixins: [
      homepageContentMixin,
    ],

    computed: {
      minHeight () {
        const height = this.$vuetify.breakpoint.mdAndUp ? '100vh' : '50vh'

        return `calc(${height} - ${this.$vuetify.application.top}px)`
      },
      organizationTitle() {
        return this.organizationHomepageData ? this.organizationHomepageData.title : this.$t('home.title')
      },
      organizationDescription() {
        return this.organizationHomepageData ? this.organizationHomepageData.description : this.$t('home.description')
      },
      organizationCustomerTitle() {
        return this.organizationHomepageData ? this.organizationHomepageData.customer_title : this.$t('home.potential_signer')
      },
      organizationCustomerDescription() {
        return this.organizationHomepageData ? this.organizationHomepageData.customer_description : this.$t('home.potential_signer_description')
      },
    },
  }
</script>
