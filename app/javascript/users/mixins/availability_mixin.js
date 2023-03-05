// import Vue from 'vue'
import axios from 'axios'

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
      const escaped_email = escape(email.replace('+', '%2B'))
      const url = `${this.$store.state.application.urls.available_user}?email=${escaped_email}`
      return axios.get(url, { skipInterceptors: true })
        .then(response => {
          const body = response.data
          this.resultAvailability = body.available === true
          this.resultCustomerCreatedByWeb = body.web
          if (!!this.serverSideErrors) this.serverSideErrors = {}
          this.serverSideErrors['email'] = this.resultAvailability ? null : [this.$t('errors.already_exists')]
          return this.resultAvailability
        }, err => {
          console.log('checkEmailAvailability', err)
          const body = err.data
          if (!!this.serverSideErrors) this.serverSideErrors = {}
          this.serverSideErrors['email'] = [body ? body.error : err]
          this.resultCustomerCreatedByWeb = null
          this.resultAvailability = false
          return false
        }).finally(_ => this.checkingAvailability = false)
    },
  },
}
