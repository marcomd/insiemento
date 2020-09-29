import Vue from 'vue'

export const availabilityMixin = {
  data() {
    return {
      checkingAvailability: false,
      resultAvailability: null,
    }
  },
  computed: {
    showAvailabilityIcon() {
      return !this.checkingAvailability && this.resultAvailability
    },
    showNotAvailabilityIcon() {
      return !this.checkingAvailability && this.resultAvailability == false
    },
  },
  methods: {
    checkEmailAvailability(email) {
      this.checkingAvailability = true
      const url = `${this.$store.state.application.urls.available_user}?email=${email}`
      return Vue.http.get(url, { skipInterceptors: true })
        .then(response => {
          this.resultAvailability = response.body.available === true
          this.resultCustomerCreatedByWeb = response.body.web
          if (!!this.serverSideErrors) this.serverSideErrors = {}
          this.serverSideErrors['email'] = this.resultAvailability ? null : [this.$t('errors.already_exists')]
          return this.resultAvailability
        }, err => {
          console.log('checkEmailAvailability', err)
          if (!!this.serverSideErrors) this.serverSideErrors = {}
          this.serverSideErrors['email'] = [err.body ? err.body.error : err]
          this.resultCustomerCreatedByWeb = null
          this.resultAvailability = false
          return false
        }).finally(_ => this.checkingAvailability = false)
    },
  },
}
