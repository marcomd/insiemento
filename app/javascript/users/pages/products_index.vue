<template>
  <v-container fill-height class="d-flex justify-center">

    <ProductsTable :products="products" @select-product="setProduct"/>
    <h3 v-if="products.length == 0 && !loading"
        class="d-flex justify-center subtitle">{{ $t('product.list.none') }}</h3>

    <ProductsCards v-if="selectedProducts.length > 0" :products="selectedProducts" />
    <h3 v-else-if="selectedProducts.length == 0 && !loading"
        class="d-flex justify-center subtitle">{{ $t('product.list.none_selected') }}</h3>
    <v-card v-else
            elevation="0"
            class="mb-12">
      <v-progress-circular
              color="primary"
              size="50"
              indeterminate>
      </v-progress-circular>
    </v-card>
  </v-container>
</template>

<script>
  // Components
  import ProductsCards from '../components/products/products_cards'
  import ProductsTable from '../components/products/products_table'
  // import { orderMixin } from '../mixins/order_mixin'
  import { productMixin } from '../mixins/product_mixin'

  import { mapState, mapActions } from 'vuex'

  export default {
    created() {
      this.fetchProducts()
    },
    components: {
      ProductsCards,
      ProductsTable,
    },
    mixins: [productMixin],
    data() {
      return {
      }
    },
    computed: {
      ...mapState('product', ['products']),
      ...mapState('order', ['order']),
      ...mapState('layout', ['loading']),
    },
    methods: {
     ...mapActions('product', ['fetchProducts']),
      setProduct({product}) {
        console.log(' dashboard setProduct', product.id)
        this.$router.push({ name: 'ProductShow', params: { id: product.id } })
      }
    },
  }
</script>

<style lang="scss">

</style>
