<template>
  <v-container>
    <v-row align='center' justify='center'>
      <v-col cols='12' sm='8' md='6' lg='4'>
        <p>
          {{ $t('session.signed_up_body') }}
        </p>
        <router-link :to='{name: "confirmationEmail"}'>
          {{ $t("session.resend_confirmation_email") }}
        </router-link>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
  export default {}
</script>
