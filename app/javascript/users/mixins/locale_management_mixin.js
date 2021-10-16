import Vue from "vue"
import moment from "moment"

export const localeManagementMixin = {
  methods: {
    changeLocale(locale) {
      this.$i18n.locale = locale
      localStorage.setItem('userLocale', locale)
      Vue.http.headers.common['Accept-Language'] = locale
      moment.locale(locale)
    }
  }
}
