<template>
  <v-card>
    <h3 align="center">Pagamento {{ amount }} {{ currency }} {{ pending_payment && 'da completare' }}</h3>

    <v-card-subtitle>
        Rispettiamo le specifiche
        <a href="https://www.pcisecuritystandards.org/security_standards" _target="blank">PCI DSS (Payment Card Industry Data Security Standards)</a>
        per garantirti la massima sicurezza. I dati del pagamento non sono memorizzati sui nostri server ma vengono
        gestiti direttamente dalla piattaforma che sceglierai.
    </v-card-subtitle>

    <v-card-text v-if="!createPaymentSuccess">
        <v-row>
            <v-col cols="12" sm="6" align="center">
                <h3>Scegli il metodo di pagamento:</h3>
            </v-col>
            <v-col cols="12" sm="6">
                <v-radio-group v-model="payment_type">
                    <v-radio label="Stripe (carta di credito)" value="stripe"></v-radio>
                    <v-radio label="Paypal (coming soon)" value="paypal" disabled></v-radio>
                    <v-radio label="Bonifico bancario (coming soon)" value="bank_transfer" disabled></v-radio>
                </v-radio-group>
            </v-col>
        </v-row>
    </v-card-text>

    <v-card-text v-if="payment_type && !createPaymentSuccess" align="center">
        <v-btn large
               color="primary"
               @click="createPayment">
            Paga con {{ payment_type }}
            <v-icon v-if="createPaymentSuccess == false">mdi-emoticon-sad-outline</v-icon>
        </v-btn>
    </v-card-text>

    <v-card-text v-if="createPaymentSuccess" align="center">
        <!--div ref="card"></div-->
        <card class='stripe-card'
              :class='{ complete }'
              :stripe='public_key'
              @change='complete = $event.complete'
        />
        <v-btn large
               color="primary"
               :disabled='!complete'
               @click="confirmPayment">
            Conferma
            <v-icon v-if="confirmPaymentSuccess == false" dark>mdi-emoticon-sad-outline</v-icon>
            <v-icon class="ml-2" v-else>mdi-check</v-icon>
        </v-btn>
    </v-card-text>


  </v-card>
</template>

<script>
  import { mapState } from 'vuex'
  import { validationMixin } from 'vuelidate'
  import { required, requiredIf } from 'vuelidate/lib/validators'
  import { utilityMixin } from '../../mixins/utility_mixin'
  import { Card, confirmPaymentIntent } from 'vue-stripe-elements-plus'

  export default {
    props: {
      amount: {
        type: Number,
        required: true,
      },
      currency: {
        type: String,
        required: true,
      },
      pending_payment: {
        type: Object,
      },
    },
    mixins: [
      validationMixin,
      utilityMixin,
    ],
    components: {
      Card,
    },
    validations() {
      return {
        payment_type: { required },
      }
    },
    data() {
      return {
        payment_type: null,
        serverSideErrors: {},
        createPaymentSuccess: null,
        confirmPaymentSuccess: null,
        payment_token: null,
        payment: null,
        complete: null,
      }
    },
    computed: {
      // ccErrors() {
      //   const errors = []
      //   if (!this.$v.cc || !this.$v.cc.$dirty) return errors
      //   !!this.serverSideErrors.cc && errors.push(this.show_error_form_field(this.serverSideErrors.cc))
      //   !this.$v.cc.required && errors.push(this.$t('errors.required'))
      //   !this.$v.cc.otpValidator && errors.push(this.$t('payment.errors.cc_not_valid'))
      //   return errors
      // },
      ...mapState('application', ['current_organization']),
      public_key() {
        return this.current_organization.s_pk
      },
    },
    methods: {
      labelsPrefix() {
        return 'payment.attributes'
      },
      createPayment() {
        console.log(`createPayment ${this.payment_type}`)
        this.createPaymentSuccess = true
        if (!!this.pending_payment) return
        // this.$store
        //   .dispatch(`payment/createPayment`, {payment_type: this.payment_type}
        //   )
        //   .then(() => {
        //     console.log(`Payment sent!`)
        //     this.$store.dispatch('layout/setSnackbar', {
        //       text: 'Payment inviato al recapito che hai selezionato',
        //       color: 'success',
        //     })
        //     this.createPaymentSuccess = true
        //     this.startCountDownTimer()
        //   })
        //   .catch(error => {
        //     this.createPaymentSuccess = false
        //     if (error.body && error.body.error) {
        //       this.serverSideErrors = error.body.error
        //       this.$store.dispatch('layout/replaceAlert', {
        //         type: 'error',
        //         message: this.serverSideErrors,
        //       })
        //     } else if (error.body && error.body.errors) {
        //       this.serverSideErrors = error.body.errors
        //     } else {
        //       this.serverSideErrors = {}
        //     }
        //     console.log(`Cannot send Payment`, error.body)
        //   })
      },
      confirmPayment() {
        // this.$v.$touch()
        // if (this.$v.$invalid) return

        console.log(`confirmPayment ${this.payment_token}`)
        this.confirmPaymentSuccess = true
        confirmPaymentIntent("pi_1GhHl2FBKMhSCxMuyVwwkSam_secret_5RgBVLZL3CblZUEG4kbOjQavk")
          .then(data => {
              console.log('confirmPaymentIntent', data)
            })


        // this.$store
        //   .dispatch(`payment/confirmPayment`, {payment_id: this.payment.id}
        //   )
        //   .then(() => {
        //     console.log(`Payment confirmed!`)
        //     this.confirmPaymentSuccess = true
        //     this.$emit('completed', true)
        //   })
        //   .catch(error => {
        //     this.confirmPaymentSuccess = false
        //     if (error.body && error.body.error) {
        //       this.serverSideErrors = error.body.error
        //       this.$store.dispatch('layout/replaceAlert', {
        //         type: 'error',
        //         message: this.serverSideErrors,
        //       })
        //     } else if (error.body && error.body.errors) {
        //       this.serverSideErrors = error.body.errors
        //     } else {
        //       this.serverSideErrors = {}
        //     }
        //     console.log(`Cannot confirm Payment`, error.body)
        //   })

      },
    }
  }
</script>

<style lang="scss" scoped>


</style>
