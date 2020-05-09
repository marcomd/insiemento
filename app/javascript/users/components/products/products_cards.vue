<template>
  <v-container fluid>
    <h3 class="d-flex justify-center subtitle">
      {{ $t('product.list.selected_label') }}
      <v-btn class="ml-2"
             :loading="submitting"
             @click="checkout()"><v-icon>mdi-cart</v-icon> {{ $t('product.list.checkout') }}</v-btn>
    </h3>
    <v-row>
      <v-col cols="12">
        <v-row align="center" justify="center">
          <ProductCardLite v-for="product in products" :key="product.id" :product="product"/>
        </v-row>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
  // Components
  import ProductCardLite from './product_card_lite'
  import { orderMixin } from '../../mixins/order_mixin'
  import { productMixin } from '../../mixins/product_mixin'
  import { utilityMixin } from '../../mixins/utility_mixin'
  import { mapState } from 'vuex'

  export default {
    components: {
      ProductCardLite
    },
    mixins: [orderMixin, productMixin, utilityMixin],
    props: {
      products: {
        type: Array,
        required: true
      }
    },
    data() {
      return {
      }
    },
    computed: {
      ...mapState('order', ['order']),
      ...mapState('layout', ['submitting']),
    },
    methods: {
      checkout() {
        const product_ids = this.selectedProducts.map(product => product.id)
        console.log(`checkout products`, product_ids)
        if (this.pending_order) {
          this.$store
            .dispatch(`order/update`, {
                      order_id: this.pending_order.id,
                      params: { order: { product_ids: product_ids } }
                    }
            )
            .then( _ => {
              console.log(`checkout updateOrder ${this.order.id} OK `)
              this.$router.push({ name: 'OrderShow', params: { id: this.pending_order.id } })
            })
            .catch(error => {
              const message = error && error.body ? error.body : error

              this.$store.dispatch('layout/replaceAlert', {
                type: 'error',
                message: message
              })
              console.log(`Cannot update order ${this.order.id}`, error)
            })
        } else {
          this.$store
                  .dispatch(`order/create`, {
                            order: { start_on: this.tomorrowDate, product_ids: product_ids }
                          }
                  )
                  .then( _ => {
                    console.log(`checkout create order OK `)
                    this.$router.push({ name: 'OrderShow', params: { id: this.pending_order.id } })
                  })
                  .catch(error => {
                    // const myObject = error && error.body ? error.body : error
                    const message = error && error.body ? error.body : error
                    this.$store.dispatch('layout/replaceAlert', {
                      type: 'error',
                      message: message
                    })
                    console.log(`Cannot create order`, error)
                  })
        }
      },
    }
  }
</script>

<style lang="scss" scoped>

</style>
