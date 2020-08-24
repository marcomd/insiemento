<template>
  <v-container>
    <v-row>
      <v-col>

        <OrderCardFull v-if="order" :order="order"/>
        <div v-else-if="loading" class="text-center">
          <v-progress-circular
            size="50"
            color="primary"
            indeterminate>
          </v-progress-circular>
        </div>
        <div v-else
             class="text-center">
          <v-btn x-large
                 color='success'
                 class='mr-2 mb-2'
                 :to='{name: "dashboard"}'>
            {{ $t('sidebar.dashboard') }}
          </v-btn>
        </div>
      </v-col>
    </v-row>

    <v-row>
      <v-col>
        <!--v-card elevation="1">
          <v-card-title>Scegli il metodo di pagamento:</v-card-title>

          <stripe-elements
                  ref="elementsRef"
                  :pk="publishableKey"
                  :amount="amount"
                  :locale="$i18n.locale"
                  @token="tokenCreated"
                  @loading="loading = $event"
          >
          </stripe-elements>
          <v-card-title>Paga in modo sicuro con la piattaforma Stripe</v-card-title>
        </v-card-->
        <PaymentSelection v-if="order && order.amount_to_pay" :amount="order.amount_to_pay" :currency="order.currency" :pending_payment="pending_payment" />
      </v-col>
    </v-row>

    <v-row>
      <v-col class="text-center">
        <!--stripe-checkout
                ref="checkoutRef"
                :pk="publishableKey"
                :items="items"
                :successUrl="successUrl"
                :cancelUrl="cancelUrl"
        >
          <template slot="checkout-button">
            <v-btn x-large
                   color='primary'
                   class='mr-2 mb-2'
                   :loading="submitting"
                   @click="payOrder"
            >
              {{ $t('order.pay_action') }}
            </v-btn>
          </template>
        </stripe-checkout-->
        <!--v-btn x-large
               color='primary'
               class='mr-2 mb-2'
               :loading="submitting"
               @click="payOrder"
        >
          {{ $t('order.pay_action') }}
        </v-btn-->
      </v-col>
      <!--v-col class="text-center">
        <v-btn x-large
               class='mr-2 mb-2'
               :to='{name: "Products"}'>
          {{ $t('commons.go_back') }}
        </v-btn>
      </v-col-->
    </v-row>
  </v-container>
</template>

<script>
  import { mapState } from 'vuex'

  import OrderCardFull from '../components/orders/order_card_full'
  import PaymentSelection from '../components/orders/payment_selection'
  import { orderMixin } from '../mixins/order_mixin'

  export default {
    name: 'OrderShow',

    components: {
      OrderCardFull,
      PaymentSelection,
    },

    mixins: [orderMixin],

    created() {
      this.$store.dispatch('order/fetchOrder', {id: this.$route.params.id})
        .then(order => {
          console.log(`order show id ${this.$route.params.id} order ${order.id} `)
        }).catch( error => {
          this.$store.dispatch('layout/replaceAlert', {
            type: 'error',
            key: 'order_not_found'
          })
        console.log(`Cannot fetch order id ${this.$route.params.id}: ${error}`)
      })
    },

    data: () => {
      return {
      }
    },

    computed: {
      ...mapState('order', ['order']),
      ...mapState('layout', ['loading', 'submitting']),
      amount() {
        return this.order.amount_to_pay * 100
      },
      description() {
        return `${this.$t('order.one')} #${this.order.id} ${this.order.amount_to_pay} ${this.order.currency}`
      },
      pending_payment() {
        return this.order.payments[0]
      },
    },

    methods: {
      // updateOrder() {
      //   console.log(`updateOrder add product ${this.product.id}`)
      //   this.$store
      //     .dispatch(`order/update`, {
      //               product_id: this.product.id,
      //               params: {subscribe: !this.product.subscribed}
      //             }
      //     )
      //     .then( _ => {
      //       console.log(`updateOrder OK to ${this.product.subscribed}`)
      //     })
      //     .catch(error => {
      //       // const myObject = error && error.body ? error.body : error
      //       const message = error && error.body ? (error.body.product_id ? error.body.product_id.join(', ') : error.body.error || error.body) : error
      //       // const message = Object.keys(myObject).map( (key, index) => myObject[key]).join(', ')
      //
      //       this.$store.dispatch('layout/replaceAlert', {
      //         type: 'error',
      //         message: message
      //       })
      //       console.log(`Cannot updateOrder`, error)
      //     })
      // },
    }
  }
</script>

<style lang="scss" scoped>
</style>
