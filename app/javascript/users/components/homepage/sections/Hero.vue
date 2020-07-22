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
          <base-heading :title="$t('home.title')" />

          <base-body :html="$t('home.description')" />

          <div
            :class="$vuetify.breakpoint.smAndDown ? 'flex-column align-start' : 'align-center'"
            class="d-flex flex-wrap"
          >
            <base-btn
                :block="$vuetify.breakpoint.smAndDown"
                href="mailto:info@fractalgarden.com?subject=Richiesta%20trial%20OTP Service"
                large
                target="_blank"
            >
              Contattaci
            </base-btn>
          </div>

          <br>
          <base-heading :title="$t('home.potential_signer')" />
          <base-body>{{ $t('home.potential_signer_description') }}</base-body>
          <base-btn
              :block="$vuetify.breakpoint.smAndDown"
              href="mailto:support@insiemento.com?subject=Informazioni%20servizio%20palestre"
              large
              target="_blank"
          >
            {{ $t('sidebar.sign_up') }}
          </base-btn>

          <span class="font-weight-bold mx-4 my-4">o</span>

          <base-btn
              :ripple="false"
              class="pa-1"
              outlined
              :to="{name: 'login'}"
          >
            {{ $t('sidebar.login') }}
          </base-btn>
        </v-responsive>
      </v-container>
    </v-img>
  </section>
</template>

<script>
  export default {
    name: 'SectionHero',

    provide: {
      theme: { isDark: true },
    },

    computed: {
      minHeight () {
        const height = this.$vuetify.breakpoint.mdAndUp ? '100vh' : '50vh'

        return `calc(${height} - ${this.$vuetify.application.top}px)`
      },
    },
  }
</script>
