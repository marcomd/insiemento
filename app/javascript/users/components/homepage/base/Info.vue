<template>
  <v-theme-provider :dark="dark">
    <div>
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
        title="Progetto Open Source"
        weight="regular"
      />

      <base-body>
        Insiemento è un <a href="https://github.com/marcomd/insiemento">progetto open source</a> creato da <b>Marco Mastrodonato</b>, l'autore dell'iniziativa.
        Questo significa che chiunque può contribuire per migliorare la piattaforma e che è in continua evoluzione.
        E' sicuro sia per chi propone il servizio che per gli utilizzatori perchè l'accesso ai sorgenti garantisce futuro e trasparenza.
        Se desideri investire su di noi o fare una donazione, beh grazie, contattaci! ❤️
      </base-body>

      <!--base-btn
        class="mb-12"
        color="white"
        outlined
      >
        Contattaci
      </base-btn-->
    </div>
  </v-theme-provider>
</template>

<script>
  import { homepageContentMixin } from '../../../mixins/homepage_content_mixin'

  export default {
    name: 'BaseInfo',

    mixins: [
      homepageContentMixin,
    ],

    props: {
      title: String,
      dark: Boolean,
    },

    data: () => ({
    }),
  }
</script>
