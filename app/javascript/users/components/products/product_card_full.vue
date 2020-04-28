<template>
  <v-card
    elevation='1'>
    <v-card-title>{{ product.name }}</v-card-title>

    <v-card-text>
      <v-row>
        <v-icon large>mdi-shape</v-icon>
        <v-col>
          {{ $t('product.attributes.category') }}<br>
          <strong>{{ product.category_name }}</strong>
        </v-col>
      </v-row>

      <v-row>
        <v-icon large>mdi-currency-{{ product.currency || 'eur' }}</v-icon>
        <v-col>
          {{ $t('product.attributes.price') }}<br>
          <strong>{{ product.price }}</strong>
        </v-col>
        <v-icon large>mdi-counter</v-icon>
        <v-col>
          {{ $t('product.attributes.days') }}<br>
          <strong>{{ product.days }}</strong>
        </v-col>
      </v-row>

      <v-row v-if="product.description">
        <v-icon large>mdi-google-classroom</v-icon>
        <v-col>
          {{ $t('product.attributes.description') }}<br>
          <strong>{{ product.description }}</strong>
        </v-col>
      </v-row>

      <v-row v-if="isSelected">
        <v-icon large>mdi-cart</v-icon>
        <v-col>
          {{ $t('product.selected') }}<br>
          <v-icon color="success">mdi-check-bold</v-icon>
        </v-col>
      </v-row>

    </v-card-text>
  </v-card>
</template>

<script>
  import { utilityMixin } from '../../mixins/utility_mixin'
  import { orderMixin } from '../../mixins/order_mixin'
  import { productMixin } from '../../mixins/product_mixin'

  export default {
    components: {
    },
    mixins: [
      utilityMixin,
      orderMixin,
      productMixin,
    ],
    props: {
      product: {
        type: Object,
        required: true
      },
    },
    computed: {
    }
  }
</script>

<style lang="scss" scoped>

</style>
