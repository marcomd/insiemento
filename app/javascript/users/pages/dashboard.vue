<template>
  <v-container fill-height class="d-flex justify-center">

    <!--OrdersListCards v-if="orders.length > 0" :orders="orders" />
    <h3 v-else-if="orders.length == 0 && !loading"
        class="d-flex justify-center subtitle">{{ $t('order.list.none') }}</h3>
    <v-card v-else
            elevation="0"
            class="mb-12">
      <v-progress-circular
        color="primary"
        size="50"
        indeterminate>
      </v-progress-circular>
    </v-card-->
  </v-container>
</template>

<script>
  // Components
//  import OrdersListCards from '../orders/orders_list_cards'

  import { mapState, mapActions } from 'vuex'

  export default {
    created() {
//      this.fetchOrders()
    },
    components: {
//      OrdersListCards
    },
    data() {
      return {
      }
    },
    computed: {
//      ...mapState('order', ['orders']),
      ...mapState('layout', ['loading']),
    },
    methods: {
//      ...mapActions('order', ['fetchOrders'])
    },
  }
</script>

<style lang="scss">

</style>
