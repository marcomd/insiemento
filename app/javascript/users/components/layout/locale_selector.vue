<template>
  <v-menu bottom :close-on-click='true'>
    <template v-slot:activator='{ on }'>
      <v-btn text v-on='on'>
        {{ currentLocale }}
      </v-btn>
    </template>
    <v-list>
      <v-list-item
          v-for='(locale, index) in availableLocales'
          :key='index'
          @click='changeLocale(locale.value)'
      >
        <v-list-item-title>{{ locale.label }}</v-list-item-title>
      </v-list-item>
    </v-list>
  </v-menu>
</template>

<script>
import { localeManagementMixin } from "../../mixins/locale_management_mixin"

export default {
  name: "LocaleSelector",

  mixins: [
    localeManagementMixin
  ],

  computed: {
    currentLocale() {
      return this.$i18n.locale
    },
    availableLocales() {
      return this.$i18n.availableLocales.map((locale) => {
        return {
          label: this.$i18n.t('locales.' + locale),
          value: locale
        }
      })
    }
  },
}
</script>
