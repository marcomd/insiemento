// import Vue from "vue"
import moment from "moment"
import axios from "axios"

export const localeManagementMixin = {
  methods: {
    changeLocale(locale) {
      this.$i18n.locale = locale
      localStorage.setItem('userLocale', locale)
      axios.defaults.headers.common['Accept-Language'] = locale
      moment.locale(locale)
    }
  }
}
