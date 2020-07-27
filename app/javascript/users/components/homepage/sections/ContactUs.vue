<template>
  <v-theme-provider dark>
    <base-section
      id="contact-us"
      class="primary"
      space="40"
    >
      <v-container>
        <v-row justify="center">
          <v-col cols="10">
            <base-title
              :space="$vuetify.breakpoint.mdAndUp ? 0 : 4"
              title="DOMANDE?"
            />

            <base-body space="0">
              <span class="white--text">
                Per qualsiasi chiarimento scrivici, siamo a tua disposizione.
              </span>
            </base-body>
          </v-col>

          <v-col
            cols="12"
            md="2"
          >
            <base-btn
              :block="$vuetify.breakpoint.smAndDown"
              color="white"
              :href="`mailto:${organizationEmail}?subject=Informazioni%20servizio%20palestre`"
              large
              outlined
              target="_blank"
            >
              Contattaci
            </base-btn>
          </v-col>
        </v-row>
      </v-container>
    </base-section>
  </v-theme-provider>
</template>

<script>
  import { mapState } from 'vuex'
  import { homepageContentMixin } from '../../../mixins/homepage_content_mixin'

  export default {
    name: 'SectionContactUs',

    mixins: [
      homepageContentMixin,
    ],

    computed: {
      ...mapState('application', ['current_organization']),
    },
  }
</script>
