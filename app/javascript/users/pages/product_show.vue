<template>
  <v-container>
    <v-row align='center' justify='center'>
      <v-col cols='12' sm='8'>

        <ProductCardFull v-if="product" :product="product"/>
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
      <v-col class="text-center">
        <v-btn x-large
               color='primary'
               class='mr-2 mb-2'
               :loading="submitting"
               @click="isSelected ? removeFromCart() : addToCart()"
        >
          {{ isSelected ? $t('product.unselect_action') : $t('product.select_action') }}
        </v-btn>
      </v-col>
      <v-col class="text-center">
        <v-btn x-large
               class='mr-2 mb-2'
               :to='{name: "Products"}'>
          {{ $t('commons.go_back') }}
        </v-btn>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
  import { mapState } from 'vuex'

  import ProductCardFull from '../components/products/product_card_full'
  // import { orderMixin } from '../mixins/order_mixin'
  import { productMixin } from '../mixins/product_mixin'

  export default {
    name: 'ProductShow',
    components: {
      ProductCardFull
    },
    mixins: [productMixin],
    created() {
      this.$store.dispatch('product/fetchProduct', {id: this.$route.params.id})
        .then(product => {
          console.log(`product show id ${this.$route.params.id} product ${product.id} `)
        }).catch( error => {
          this.$store.dispatch('layout/replaceAlert', {
            type: 'error',
            key: 'product_not_found'
          })
        console.log(`Cannot fetch product id ${this.$route.params.id}: ${error}`)
      })
    },
    data: () => {
      return {
      }
    },
    computed: {
      ...mapState('product', ['product']),
      ...mapState('order', ['order']),
      ...mapState('layout', ['loading', 'submitting']),
    },
    methods: {
      addToCart() {
        console.log(`addToCart product ${this.product.id} `)
        this.$store.dispatch(`order/addProductToCart`, this.product )
                .then( _ => {
                  console.log(`addToCart OK`)
                })
                .catch(error => {
                  const message = error && error.body ? (error.body.product_id ? error.body.product_id.join(', ') : error.body.error || error.body) : error
                  this.$store.dispatch('layout/replaceAlert', {
                    type: 'error',
                    message: message
                  })
                  console.log(`Cannot addToCart ${this.product.id}`, error)
                })
      },
      removeFromCart() {
        console.log(`removeFromCart product ${this.product.id} `)
        this.$store.dispatch(`order/removeProductFromCart`, this.product.id)
                .then( _ => {
                  console.log(`removeFromCart OK`)
                })
                .catch(error => {
                  const message = error && error.body ? (error.body.product_id ? error.body.product_id.join(', ') : error.body.error || error.body) : error
                  this.$store.dispatch('layout/replaceAlert', {
                    type: 'error',
                    message: message
                  })
                  console.log(`Cannot removeFromCart ${this.product.id}`, error)
                })
      },
      updateOrder() {
        console.log(`updateOrder add product ${this.product.id}`)
        this.$store
          .dispatch(`order/update`, {
                    product_id: this.product.id,
                    params: {subscribe: !this.product.subscribed}
                  }
          )
          .then( _ => {
            console.log(`updateOrder OK to ${this.product.subscribed}`)
          })
          .catch(error => {
            // const myObject = error && error.body ? error.body : error
            const message = error && error.body ? (error.body.product_id ? error.body.product_id.join(', ') : error.body.error || error.body) : error
            // const message = Object.keys(myObject).map( (key, index) => myObject[key]).join(', ')

            this.$store.dispatch('layout/replaceAlert', {
              type: 'error',
              message: message
            })
            console.log(`Cannot updateOrder`, error)
          })
      },
    }
  }
</script>

<style lang="scss" scoped>
</style>
