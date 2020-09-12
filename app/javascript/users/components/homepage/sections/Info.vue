<template>
  <v-theme-provider dark>
    <base-section
      id="info-alt"
      class="grey darken-4 pt-2"
    >
      <v-responsive
        class="mx-auto"
        max-width="1400"
      >
        <v-container fluid>
          <v-row>
            <v-col
              cols="12"
              md="3"
            >
              <base-img
                  :src="organizationLogo"
                  contain
                  max-width="128"
                  min-height="78"
                  width="100%"
              />

              <base-title
                  size="body-1"
                  space="4"
                  :title="organizationBioTitle"
                  weight="regular"
              />

              <base-body v-html="organizationBioDescription" />
            </v-col>

            <v-col
              cols="12"
              md="3"
              class="mt-12"
              v-if="contacts"
            >
              <base-info-card title="Contatti" />

              <base-business-contact :elements="contacts" dense />
            </v-col>

            <v-col
                cols="12"
                md="3"
                class="mt-12"
                v-if="socials"
            >
              <base-info-card title="Social" />

              <base-social :elements="socials" dense />
            </v-col>

            <v-col
              cols="12"
              md="3"
              class="mt-12"
            >
              <base-info-card title="Leggi attentamente">
                <v-btn
                    text
                    class="mb-8"
                    :to='{name: "TermsAndConditions"}'
                >Termini e condizioni</v-btn>
                <v-btn
                    text
                    class="mb-8"
                    :to='{name: "Privacy"}'
                >Privacy Policy</v-btn>
              </base-info-card>
            </v-col>

            <!--v-col
              cols="12"
              md="3"
              class="mt-12"
            >
              <instagram />
            </v-col-->
          </v-row>
        </v-container>
      </v-responsive>
    </base-section>
  </v-theme-provider>
</template>

<script>
  import { homepageContentMixin } from '../../../mixins/homepage_content_mixin'

  export default {
    name: 'SectionBusinessInfo',

    mixins: [
      homepageContentMixin,
    ],

    components: {
      // InfoFeatures: () => import('@/components/InfoFeatures'),
      // Instagram: () => import('@/components/Instagram'),
    },

    computed: {
      organizationBioTitle() {
        return this.organizationHomepageData ? this.organizationHomepageData.homepage_bio_title : this.$t('home.bio_title')
      },
      organizationBioDescription() {
        return this.organizationHomepageData ? this.organizationHomepageData.homepage_bio_description : this.$t('home.bio_description')
      },
      contacts() {
        return this.organizationHomepageData ? this.organizationHomepageData.homepage_contacts : this.applicationContacts
      },
      socials() {
        return this.organizationHomepageData ? this.organizationHomepageData.homepage_socials : null
      },
      applicationContacts() {
        return [
          {
            icon: 'mdi-map-marker-outline',
            title: 'Indirizzo',
            text: 'San Giuliano Milanese (MI)<br>Italy',
          },
          {
            icon: 'mdi-cellphone',
            title: 'Telefono',
            text: '339 278S467',
          },
          {
            icon: 'mdi-email',
            title: 'Email',
            text: 'info@insiemento.com',
          },
        ]
      },
    }
  }
</script>

<style lang="scss">
  #info-alt a {
    text-decoration: none;
  }
</style>
