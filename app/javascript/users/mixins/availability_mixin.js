import Vue from 'vue'

export const availabilityMixin = {
  data() {
    return {
      checkingAvailability: false,
      resultAvailability: null,
      resultCustomerCreatedByWeb: null,
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
      const url = `${this.$store.state.application.urls.available_customer}?email=${email}`
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
    checkFiscalCodeAvailability(fiscal_code) {
      // console.log(`checkFiscalCodeAvailability ${fiscal_code}`)
      this.checkingAvailability = true
      const url = `${this.$store.state.application.urls.available_invoice_account}?fiscal_code=${fiscal_code}`
      return Vue.http.get(url, { skipInterceptors: true })
        .then(response => {
          this.resultAvailability = response.body.available === true
          if (!!this.serverSideErrors) this.serverSideErrors = {}
          this.serverSideErrors['fiscal_code'] = this.resultAvailability ? null : [this.$t('errors.fiscal_code_already_exists')]
          return this.resultAvailability
        }, err => {
          console.log('checkFiscalCodeAvailability', err)
          if (!!this.serverSideErrors) this.serverSideErrors = {}
          this.serverSideErrors['fiscal_code'] = [err.body ? err.body.error : err]
          this.resultAvailability = false
          return false
        }).finally(_ => this.checkingAvailability = false)
    },
  },
}
